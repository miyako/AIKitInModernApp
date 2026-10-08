# モダンな4Dアプリケーションで4D AIKitを使用する

Using 4D AIKit in Modern 4D Applications (Technical Note 26-01): Japanese edition.

このテクニカルノートでは、4D AIKitの基礎と設定方法を紹介し、テキスト、画像、会話の各機能を組み合わせたビジネス向けのデモを通じて、その実用的な使い方を説明します。デモのAIドキュメントマネージャーでは、請求書や契約書などの文書をアップロードすると、ビジョンモデルが構造化データを抽出し、4種類の要約を生成します。さらに、その文書についてAIとチャットできます。AIの処理はワーカーで非同期に実行されるため、ユーザーインターフェースはブロックされません。コスト、パフォーマンス、セキュリティなど、デプロイ時の注意点も取り上げます。

This technical note introduces 4D AIKit, how to configure it, and how to combine its text, vision and chat features in a business demo: an AI document manager that extracts structured data from uploaded documents, generates four kinds of summaries and lets you chat about each document, with all AI calls running asynchronously in workers.

## Download

| | |
|---|---|
| PDF (Japanese) | [26-01_AIKitInModernApp_ja.pdf](https://github.com/miyako/AIKitInModernApp/releases/latest/download/26-01_AIKitInModernApp_ja.pdf) |
| 4D demo | [AIKitInModernApp.zip](https://github.com/miyako/AIKitInModernApp/releases/latest/download/AIKitInModernApp.zip) |
| Original (English) | `document/26-01_AIKitInModernApp.pdf` |

## Demo

- 4D version: 4D 21 R3 or later (tested with 21 R3). The 4D AIKit component is installed through the project dependencies (`Project/Sources/dependencies.json`); PDF conversion uses the pdfium plugin in `Plugins/`.
- Open `demo/AIKitInModernApp/Project/AIKitInModernApp.4DProject`.
- Languages: English and Japanese. The UI follows the system language; the XLIFF files are in `Resources/<lang>.lproj/`.
- API key: copy `Project/Sources/AIProviders.example.json` to `Project/Sources/AIProviders.json` and enter your OpenAI key (or edit it on the AI page of the Settings). This file is ignored by git; never commit it. Models, max tokens and temperature are set in the AI Configuration dialog and saved to `aiconfig.json` in the database folder.
- At startup the Document Manager opens without blocking, in the application process; if no API key is found, the AI Configuration dialog opens instead. Choosing a menu item again brings the existing window to the front.

## Differences from the original

- Screenshots (figures 1, 3, 5, 7, 8 and 9) were retaken with the localised demo. Diagram labels (figures 2, 4, 6 and 10) are translated; the decision in figure 2 is now "API key found?".
- Dates in the analysis prompt and the examples use YYYY-MM-DD, as in the demo code (the original text says MM-DD-YYYY).
- The prompt blocks show the English prompts as the demo sends them, with the added line that asks for answers in the UI language.
- The demo:
  - XLIFF localisation of menus, forms, messages and window titles (English and Japanese).
  - The AI prompts stay in English and end with a line asking the model to answer in the UI language.
  - A computed `statusLabel` attribute shows the document status in the UI language; the summary-type drop-down shows localised labels and keeps the stored codes.
  - The API key is read from `Project/Sources/AIProviders.json` (4D AIKit provider settings) instead of `aiconfig.json`; the dialog no longer stores the key.
  - Non-blocking startup windows (`DIALOG(...; *)` in the application process), reused on later calls.
  - Bug fix: the prompts contained literal `\n` instead of line breaks.

## Editing and rebuilding

The PDF is generated from plain-text sources. Edit them and run `make`.

| File | What |
|---|---|
| `src/ja.md` | Translated body text. **Don't touch code blocks** (`make check` verifies them). |
| `figures/fig-NN.ja.txt` | Text drawn in figure NN. Line N corresponds to line N of `fig-NN.en.txt`: an identical line keeps the original, an empty line erases it. |
| `figures/layout/fig-NN.json` | Per-label overrides for size, weight, alignment and position; `"replace"` uses a ready-made image |
| `glossary.md` | Terminology |

```sh
make            # check → figures → build/26-01_AIKitInModernApp_ja.pdf
make check      # code blocks unchanged, figure references complete
make review     # contact sheets of the figures (build/contact-N.png)
make release-assets
```

Requirements: Python 3, Google Chrome, CJK fonts, and Tesseract (only needed for re-extraction).
See the [localisation template](https://github.com/miyako/4d-technote-localisation-template) for the full workflow.

## Credits

- Original: Soukaina Bachikh, Customer Success Engineer, 4D Inc.
- Produced with [4d-technote-localisation-template](https://github.com/miyako/4d-technote-localisation-template) and GitHub Copilot.
