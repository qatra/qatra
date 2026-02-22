#!/bin/bash

# Configuration
REPO_URL="https://github.com/qatra/qatra.git"

echo "🚀 Starting deployment to GitHub Pages..."

# 1. Build the project
echo "📦 Building Flutter Web..."
flutter build web --base-href "/qatra/" --release

# 2. Add .nojekyll
touch build/web/.nojekyll

# 3. Deploy
echo "📤 Pushing to GitHub Pages..."
cd build/web
rm -rf .git
git init
git add .
git commit -m "Deploy to GitHub Pages"
git branch -M gh-pages
git remote add origin $REPO_URL
git push -u origin gh-pages --force

echo "✅ Deployment complete! Your app will be live at https://qatra.github.io/qatra/ shortly."
