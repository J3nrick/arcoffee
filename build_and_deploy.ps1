# ==============================================================================
# Arcoffee — Production Web Build & Deployment Automation Script
# Target: Flutter Web (CanvasKit / Wasm Optimized)
# ==============================================================================

Write-Host "☕ [1/4] Cleaning previous build artifacts..." -ForegroundColor Cyan
flutter clean

Write-Host "📦 [2/4] Fetching latest dependencies..." -ForegroundColor Cyan
flutter pub get

Write-Host "🔍 [3/4] Running static analysis..." -ForegroundColor Cyan
flutter analyze

Write-Host "🚀 [4/4] Building production Flutter Web bundle (CanvasKit)..." -ForegroundColor Green
flutter build web --web-renderer canvaskit --release --pwa-strategy offline-first

if (Test-Path "build\web\index.html") {
    Write-Host ""
    Write-Host "✅ ==================================================================" -ForegroundColor Green
    Write-Host "🎉 Arcoffee Web App successfully built for production!" -ForegroundColor Green
    Write-Host "📁 Output Directory: $(Get-Location)\build\web" -ForegroundColor Yellow
    Write-Host "✅ ==================================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Deployment Quick Reference:" -ForegroundColor Cyan
    Write-Host "  • Vercel:          npx vercel --prod build/web" -ForegroundColor White
    Write-Host "  • Firebase:        firebase deploy --only hosting" -ForegroundColor White
    Write-Host "  • Netlify:         npx netlify deploy --dir=build/web --prod" -ForegroundColor White
    Write-Host "  • IIS / Nginx:     Copy the contents of build/web to your web root." -ForegroundColor White
    Write-Host ""
} else {
    Write-Host "❌ Build failed. Please inspect console logs above." -ForegroundColor Red
    exit 1
}
