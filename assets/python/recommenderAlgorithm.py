from flask import Flask, request, jsonify
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.feature_extraction.text import TfidfVectorizer

app = Flask(__name__)

def itemBasedCollaborativeFiltering(dataset, userID):
    df = pd.DataFrame(dataset)
    df_wide = df.pivot_table(index='userID', columns='attractionName', values='rating').fillna(0)
    
    if userID not in df_wide.index or (df_wide.loc[userID] == 0).all():
        return []  # Return empty list when the user has no rated attractions

    def get_recommendations(user_id, n):
        item_similarities = cosine_similarity(df_wide.T)
        item_sim_matrix_df = pd.DataFrame(
            item_similarities,
            index=df_wide.columns,
            columns=df_wide.columns
        )
        
        user_ratings = df_wide.loc[user_id]
        unrated_items = user_ratings[user_ratings == 0].index
        
        if len(unrated_items) == 0:
            similar_items_names = user_ratings[user_ratings > 0].sort_values(ascending=False).head(n).index.tolist()
        else:
            similar_items_names = item_sim_matrix_df[unrated_items][user_ratings > 0].sum().sort_values(ascending=False).head(n).index.tolist()

        return similar_items_names
    
    recommendations = get_recommendations(userID, 15)
    return recommendations

def contentBasedFiltering(dataset, userID):
    df = pd.DataFrame(dataset)

    tfidf = TfidfVectorizer(stop_words='english')
    df['tfidf'] = list(tfidf.fit_transform(df['attractionDescription']).toarray())

    df_user = df[df['userID'] == userID]
    if len(df_user) == 0 or (df_user['rating'] == 0).all():
        return []  # Return empty list when the user has no rated attractions

    def get_recommendations(userID, n):
        avg_tfidf = df_user['tfidf'].mean()

        df['similarity'] = df['tfidf'].apply(lambda x: cosine_similarity([x], [avg_tfidf])[0][0])
        df['similarity'] = pd.to_numeric(df['similarity'])

        df_sorted = df.sort_values(by=['similarity'], ascending=False)
        df_sorted = df_sorted.drop_duplicates(subset='attractionName')

        rated_attractions = set(df_user['attractionName'])
        df_sorted = df_sorted[~df_sorted['attractionName'].isin(rated_attractions)]

        recommendations = df_sorted['attractionName'].head(n).tolist()
        return recommendations
    
    recommendations = get_recommendations(userID, 15)
    return recommendations

def weightedHybridApproach(itemBasedResults, contentBasedResults, alpha):

    if not itemBasedResults and not contentBasedResults:
        return []  # Return empty list when both recommendation lists are empty

    weightedResults = {}

    for i in range(min(10, len(itemBasedResults))):
        if itemBasedResults[i] in contentBasedResults:
            weightedResults[itemBasedResults[i]] = alpha
        else:
            weightedResults[itemBasedResults[i]] = (1 - alpha) / 2

    for i in range(min(10, len(contentBasedResults))):
        if contentBasedResults[i] in weightedResults:
            weightedResults[contentBasedResults[i]] += alpha
        else:
            weightedResults[contentBasedResults[i]] = (1 - alpha) / 2
    
    finalRankings = sorted(weightedResults.items(), key=lambda x: x[1], reverse=True)

    # Extract final top 5 recommendations
    finalRecommendations = [attractionName for attractionName, _ in finalRankings[:5]]
    return finalRecommendations

@app.route("/recommend-attractions", methods=['POST'])
def recommend_attractions():
    data = request.get_json()
    dataset = data['dataset']
    userID = data['userID']

    itemBasedResults = itemBasedCollaborativeFiltering(dataset, userID)
    contentBasedResults = contentBasedFiltering(dataset, userID)
    weightedResults = weightedHybridApproach(itemBasedResults, contentBasedResults, 0.5)

    def fetch_attraction_details(attractions):
        df = pd.DataFrame(dataset)
        details = []

        for attraction in attractions:
            attr_details = df[df['attractionName'] == attraction][['attractionLocation', 'attractionImage']].to_dict('records')[0]
            attr_details['attractionName'] = attraction
            details.append(attr_details)
        
        return details

    output = {
        "collabFilteringOutput": fetch_attraction_details(itemBasedResults),
        "contentBasedFilteringOutput": fetch_attraction_details(contentBasedResults),
        "weightedHybridApproachOutput": fetch_attraction_details(weightedResults)
    }
    
    return jsonify(output)

if __name__ == "__main__":
    app.run()