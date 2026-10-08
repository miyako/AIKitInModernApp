# 用語集 / Glossary

Keep terminology consistent across `src/<target>.md` and `figures/*.<target>.txt`.
Change an entry here first, then search and replace in both places.

Style (ja): です・ます調. Half-width alphanumerics, no space between Japanese and Latin text (e.g. `4D.Vector型`).
Full-width `（）` and `：` in prose. First occurrence of a technical term: 日本語（English）.

## 4D terms (from the official 4D Japanese documentation)

| English | 日本語 | Notes |
|---|---|---|
| entity / entity selection | エンティティ / エンティティセレクション | |
| datastore | データストア | |
| dataclass | データクラス | |
| attribute | 属性 | |
| computed attribute | 計算属性 | |
| collection | コレクション | |
| object | オブジェクト | |
| method | メソッド | |
| project method | プロジェクトメソッド | |
| function | 関数 | |
| class | クラス | |
| parameter | 引数 | |
| form | フォーム | |
| form object | フォームオブジェクト | |
| list box | リストボックス | |
| web area | Webエリア | |
| 4D Web Server | 4D Webサーバー | |
| worker | ワーカー | |
| process | プロセス | |
| query | クエリ | |
| formula | フォーミュラ | |
| component | コンポーネント | |
| built-in component | ビルトインコンポーネント | developer.4d.com/docs/ja/aikit |
| shared singleton | 共有シングルトン | |
| singleton | シングルトン | |
| worker process | ワーカープロセス | |
| On Startup database method | On Startupデータベースメソッド | |
| Components folder | Componentsフォルダー | |
| Plugins folder | Pluginsフォルダー | |
| database folder | データベースフォルダー | |

## Document-specific terms

| English | 日本語 | Notes |
|---|---|---|
| chat completions (API) | チャット補完（API） | 4D AIKit ja docs |
| vision helper | ビジョンヘルパー | 4D AIKit ja docs |
| compatible provider | 互換性のあるプロバイダー | 4D AIKit ja docs |
| provider settings file (AIProviders.json) | プロバイダー設定ファイル | 4D AIKit / 4D 21 R3; file name kept |
| Settings (AI page) | 設定（AIページ） | 4D 21 R3 |
| API key | APIキー | |
| prompt / prompt engineering | プロンプト / プロンプトエンジニアリング | |
| system message / user message | システムメッセージ / ユーザーメッセージ | |
| role (system, user, assistant) | ロール | role names stay in English |
| token | トークン | |
| temperature | temperature | parameter name, not translated |
| model | モデル | |
| vision (capability) | ビジョン | |
| large language model | 大規模言語モデル | |
| hallucination | ハルシネーション | |
| zero-shot learning | ゼロショット学習 | |
| document (business document) | 文書 / ビジネス文書 | ドキュメント only in UI names |
| extracted data | 抽出データ | |
| summary | 要約 | |
| executive summary | 重役向けの要約 | no katakana |
| conversation / chat | 会話 / チャット | |
| conversation history | 会話履歴 | |
| configuration | 設定 | |
| configuration file | 設定ファイル | |
| workflow | ワークフロー | |
| pipeline | パイプライン | |
| legend | 凡例 | figures |
| decision (flowchart) | 判定 | figures |
| asynchronous processing | 非同期処理 | |
| polling | ポーリング | |
| rate limit | レート制限 | |
| data anonymization | データの匿名化 | |

## UI labels in the demo (target strings for the Phase 5 XLIFF)

| English | 日本語 | Notes |
|---|---|---|
| AI Document Manager | AIドキュメントマネージャー | DocumentManager form title |
| Document Manager | ドキュメントマネージャー | |
| AI Configuration | AI設定 | dialog |
| Upload Document | 文書をアップロード | |
| Analyze Selected | 選択した文書を解析 | the English note says "Analyze Document" |
| Delete Document | 文書を削除 | |
| Document Preview | 文書プレビュー | |
| AI Summary | AI要約 | |
| Generate | 生成 | |
| Chat Messages | チャットメッセージ | |
| Send | 送信 | |
| Extracted Data | 抽出データ | |
| Documents | 文書 | list label |
| Edit / Cancel / Delete / OK | 編集 / キャンセル / 削除 / OK | 4D built-in Common* XLIFF |
| Brief / Detailed / Executive / KeyPoints | 簡潔 / 詳細 / 重役 / 要点 | summary types; stored codes stay in English |
| Uploaded / Processing / Processed / Error | アップロード済み / 処理中 / 解析済み / エラー | document status (`statusLabel`); stored codes stay in English |
| File Name / Type / Upload Date / Status | ファイル名 / 種類 / アップロード日 / ステータス | list box headers |
| Edit Extracted Data - JSON Format | 抽出データの編集 - JSON形式 | dialog title |
| Provider / API Key / Base URL | プロバイダー / APIキー / ベースURL | AI Configuration |
| Default Model / Vision Model / Max Tokens / Temperature | デフォルトモデル / ビジョンモデル / 最大トークン数 / 温度 | AI Configuration |
| You / Assistant | あなた / アシスタント | chat roles |

## AI prompts

The prompts stay in English in every language (`Prompt_*` in `demo/AIKitInModernApp/Resources/<lang>.lproj/prompts<LANG>.xlf`).
Each prompt ends with `Prompt_ResponseLanguage`, which asks for the answer in the UI language:
"Write all human-readable text in Japanese. Keep JSON keys, HTML tags and CSS unchanged."
The ```text blocks in `src/ja.md` show the English prompts as the demo sends them, with that line.

## Proper nouns in examples

| English | 日本語 | Notes |
|---|---|---|
