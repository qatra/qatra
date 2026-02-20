#!/bin/bash

# Configuration
REPO_URL="https://github.com/abdallah-azmy/qatra-blood-donation.git"

echo "🚀 Starting deployment to GitHub Pages..."

# 1. Build the project
echo "📦 Building Flutter Web..."
flutter build web --base-href "/qatra-blood-donation/" --release

# 2. Add .nojekyll
touch build/web/.nojekyll

# 3. Deploy
echo "📤 Pushing to GitHub Pages..."
cd build/web
git init
git add .
git commit -m "Deploy to GitHub Pages"
git branch -M gh-pages
git remote add origin $REPO_URL
git push -u origin gh-pages --force

echo "✅ Deployment complete! Your app will be live at https://abdallah-azmy.github.io/qatra-blood-donation shortly."
