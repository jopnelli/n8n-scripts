#!/bin/bash

echo "🚀 n8n CLI Setup"
echo ""

# Check if config already exists
if [ -f ".env" ] || [ -f ".n8n-config.json" ]; then
    echo "⚠️  Configuration already exists. Skipping setup."
    echo ""
    exit 0
fi

# Create .env from template (recommended method)
cp .env.example .env

echo "✅ Created .env from template"
echo ""
echo "📝 Next steps:"
echo "   1. Edit .env with your credentials"
echo "   2. Get your API key from: n8n Settings → API"
echo "   3. Run: ./n8n list"
echo ""
echo "Example .env:"
cat .env
echo ""
echo "💡 Tip: You can also use .n8n-config.json if you prefer JSON format"
echo ""
