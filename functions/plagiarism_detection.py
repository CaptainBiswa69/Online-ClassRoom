import os
import fitz
import requests
import json
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

# Function to extract text from a PDF file
def extract_text_from_pdf(pdf_link):
    response = requests.get(pdf_link)
    pdf_bytes = response.content
    pdf_document = fitz.open("pdf", pdf_bytes)
    text = ""
    for page in pdf_document:
        text += page.get_text()
    return text

# Function to compute text similarity
def compute_similarity(base_text, other_texts):
    vectorizer = TfidfVectorizer()
    vectors = vectorizer.fit_transform([base_text] + other_texts)
    similarity_matrix = cosine_similarity(vectors)
    return similarity_matrix[0][1:]

if __name__ == "__main__":
    import sys

    if len(sys.argv) < 3:
        print("Usage: python plagiarism_detection.py <base_pdf_link> <pdf_links...>")
        sys.exit(1)

    base_pdf_link = sys.argv[1]
    pdf_links = sys.argv[2:]
    # print(sys.argv)

    # base_pdf_link = "https://firebasestorage.googleapis.com/v0/b/online-classroom-app-239e9.appspot.com/o/biswa2dehuri2@gmail.com%2FHistory%2Fflutter-seminar-report-pdf.pdf?alt=media&token=78da53fa-685d-4251-bc7b-f86a0b565120"
    # pdf_links = ["https://firebasestorage.googleapis.com/v0/b/online-classroom-app-239e9.appspot.com/o/biswa2dehuri2@gmail.com%2FHistory%2Fflutter-seminar-report-pdf.pdf?alt=media&token=78da53fa-685d-4251-bc7b-f86a0b565120","https://firebasestorage.googleapis.com/v0/b/online-classroom-app-239e9.appspot.com/o/biswa2dehuri2@gmail.com%2FHistory%2Fflutter-seminar-report-pdf.pdf?alt=media&token=78da53fa-685d-4251-bc7b-f86a0b565120"]


    # Extract text from the base PDF
    base_text = extract_text_from_pdf(base_pdf_link)

    # Extract text from other PDFs
    other_texts = [extract_text_from_pdf(pdf_link) for pdf_link in pdf_links]

    # Compute similarity
    similarity_scores = compute_similarity(base_text, other_texts)

    # Create a list of plagiarism results
    plagiarism_results = []
    for pdf_link, similarity_score in zip(pdf_links, similarity_scores):
        plagiarism_results.append({
            "base_pdf_link": base_pdf_link,
            "compared_pdf_link": pdf_link,
            "similarity_score": similarity_score
        })

    # Output the plagiarism results as JSON
    print(json.dumps(plagiarism_results))
