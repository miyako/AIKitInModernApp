# モダンな4Dアプリケーションで4D AIKitを使用する

Soukaina BACHIKH（4D Inc. カスタマーサクセスエンジニア）

テクニカルノート 26-01

## 要旨

最新のビジネスソリューションがインテリジェントな自動化や自然言語処理への依存を深めるなか、4DアプリケーションへのAIの統合は重要かつ不可欠なものとなっています。4D 20 R9で導入された4D AIKitはビルトインコンポーネントで、ネイティブなインターフェースを通じて、4Dを強力な大規模言語モデルやビジョンモデルに簡単に接続できます。

このテクニカルノートでは、4D AIKitの基礎を紹介し、その設定方法と使い方を説明したうえで、ビジネス向けに統合されたデモを通じてその実用的な価値を示します。このデモでは、テキスト、画像、会話の各機能を組み合わせて、AIを活用した実用的なソリューションを作成する方法を紹介します。また、コストの把握、パフォーマンスの最適化、デプロイのベストプラクティスについても重要なガイダンスを提供します。

## はじめに

人工知能（AI）は、未来の概念から実用的なビジネスツールへと変化しました。あらゆる業界の組織がAIの機能を活用して、プロセスの自動化、データからの知見の抽出、ユーザー体験の向上に取り組んでいます。4D開発者にとっての課題は、大がかりな外部依存や複雑なインフラを必要とせずに、こうした強力なAIサービスをアプリケーションに統合することでした。

4D AIKitは、4Dアプリケーションを主要なAIモデルに接続するための、ネイティブでわかりやすいインターフェースを提供することで、このニーズに応えます。文書処理システム、対話型インターフェース、インテリジェントなデータ分析ツールのいずれを構築する場合でも、4D AIKitは、エンタープライズアプリケーションに求められる堅牢性と信頼性を保ちながら、統合のプロセスを簡素化します。

## 4D AIKitの概要

### コンポーネントの概要と機能

4D AIKitは包括的なビルトインコンポーネントで、cs.AIKitネームスペースを通じて、3つの主要な機能領域を提供します：

#### テキストの生成と処理

チャット補完（chat completions）APIを使用すると、人間のようなテキストを生成して、コンテンツの作成、要約、翻訳、データの変換に利用できます。この機能により、レポート、メール、製品説明など、ビジネスアプリケーションで必要なあらゆるテキスト出力を生成できます。コンポーネントはメッセージのコレクションによって会話のコンテキストを保持するため、状態を維持したまま複数ターンの対話を行えます。

#### ビジョンと画像解析

ビジョン（vision）機能は、画像、文書、その他の視覚的なコンテンツから情報を抽出します。これにより、専用の画像処理インフラを用意することなく、光学文字認識（OCR）、物体検出、画像に関する質問応答を行えます。ビジョンヘルパークラスは、チャット補完と画像入力を組み合わせることで、画像解析を簡素化します。

#### 画像生成

画像（images）APIは、テキストの説明から視覚的なコンテンツを生成し、アプリケーションがイラスト、プレースホルダー、デザイン案をプログラムで作成できるようにします。この機能は、クリエイティブなワークフローやアセットの自動生成に役立ちます。

4D AIKitコンポーネントは、上記のAI機能に整理された形でアクセスするための、いくつかの主要なクラスで構成されています：

| クラス | 目的 | コード例 |
|---|---|---|
| **OpenAI** | API認証と設定を行うメインのクライアントクラスです。AIKitのすべての機能の入り口となります。 | `$aiClient := cs.AIKit.OpenAI.new("api-key")`<br><br>`// With config`<br>`$config := New object("model"; "gpt-4o-mini")`<br>`$aiClient := cs.AIKit.OpenAI.new("api-key"; $config)` |
| **OpenAIChatCompletionsAPI** | テキスト生成とチャット形式のAIとのやり取りを処理します。会話メッセージを処理し、AIの応答を返します。 | `$messages := New collection`<br>`$messages.push(New object("role"; "user"; "content"; "Explain AI"))`<br>`$result := $aiClient.chat.completions.create($messages; $options)` |
| **OpenAIVision/ OpenAIVisionHelper** | ビジョンタスク、画像解析、OCR、画像に関する質問応答、文書からのデータ抽出のための専用ヘルパーです。 | `$vision := $aiClient.chat.vision.fromFile($file)`<br>`$params := New object("model"; "gpt-4o")`<br>`$result := $vision.prompt("Extract text"; $params)` |
| **OpenAIImagesAPI** | テキストの説明からAIで画像を生成し、ビジュアルアセットを作成します。 | `$prompt := "Business dashboard"`<br>`$options := New object("model"; "dall-e-3"; "size"; "1024x1024")`<br>`$result := $aiClient.images.generate($prompt; $options)` |
| **OpenAIError** | APIリクエストが失敗したときに返される構造化されたエラーオブジェクトです。エラーの詳細情報を提供します。 | `$result := $aiClient.chat.completions.create($msgs; $opts)`<br>`If (Not($result.success))`<br>`  $error := $result.errors`<br>`  ALERT("Error: "+$error[0].message)`<br>`End if` |

### 互換性とセットアップ

#### システム要件

- 4D 20 R9（4D AIKitがビルトインコンポーネントとして含まれています）以降
- 外部のAIプロバイダーのAPIを呼び出すためのインターネット接続
- サポートされているAIプロバイダーのうち少なくとも1つの有効なAPIキー
- 互換性のあるプロバイダーの一覧は、次のリンクから確認できます：<https://developer.4d.com/docs/aikit/compatible-openai>

**注：** *4D 21では4D AIKitがビルトインではなくなったため、4D AIKitコンポーネントを必ず追加してください。*
{: .note }

#### サポートされているモデル

4D AIKitは、OpenAIのモデルと、OpenAI互換APIを提供するあらゆるプロバイダーのモデルをサポートしています。このコンポーネントは、統一されたインターフェースを通じて、さまざまなAIプロバイダーとシームレスに連携できるように設計されています。

OpenAIの各モデルについては、次のリンクを参照してください：<https://platform.openai.com/docs/models>

#### 基本的なAPIの設定

AIKitコンポーネントは、cs.AIKit.OpenAIクラスを通じて初期化します。これにはAPIキーと、オプションの設定パラメーターが必要です。設定では、OpenAI互換サービスのカスタムエンドポイント、パラメーターの値、デフォルトのモデルを指定できます。

```4d
// Basic configuration
var $aiClient : cs.AIKit.OpenAI
$aiClient:=cs.AIKit.OpenAI.new("your-api-key-here")

// Configuration with custom settings
var $config : Object
$config:=New object
$config.model:="gpt-4o-mini"
$config.temperature:=0.7
$config.maxTokens:=1000

$aiClient:=cs.AIKit.OpenAI.new("your-api-key-here"; $config)
```

### 設定パラメーター

- model：目的（テキスト生成、画像生成など）に応じてAIモデルを選択するために使用します
- temperature：応答のランダム性と創造性を制御するために使用します。値が低いほど一貫した出力になり、値が高いほど多様な応答が生成されます
- maxTokens：生成される応答の最大長を制限し、APIのコストを抑えるために使用します
- timeout：リクエストを打ち切るまでの、APIの応答の最大待ち時間を設定するために使用します

その他のパラメーターについては、ドキュメントを参照してください。

**注：** *クラウドのAIプロバイダーからAPIキーを取得する前に、Ollamaなどのローカルプロバイダーを使用してローカルでテストすることもできます。詳しくは次のTech Tipを参照してください：Testing 4D AIKit Without an OpenAI API Key（<https://kb.4d.com/assetid=79903>）*
{: .note }

## AI機能の実装

### アーキテクチャとベストプラクティス

4DアプリケーションへのAIの統合を成功させるには、保守性、信頼性、スケーラビリティを高める、確立されたアーキテクチャパターンに従います。

#### クラスベースのアーキテクチャ

AIの機能を専用のクラスにまとめることで、関心事を明確に分離できます。各クラスは、文書の解析、要約、会話の管理、設定といった特定の領域を担当します。この方法ではAIのロジックがカプセル化されるため、コードのテスト、保守、拡張が容易になります。

#### 非同期処理のパターン

AI APIの呼び出しは、完了までに数秒かかることがあります。これらの呼び出しをワーカープロセスで処理することで、UIのフリーズを防ぎ、アプリケーションの応答性を維持できます。このパターンでは、AI処理用のワーカープロセスを起動し、結果でデータベースを更新し、UIプロセス側ではタイマーによるポーリングで変更を反映します。

**注：** *4D AIKitには、コールバックを使用したネイティブの非同期呼び出しパターンがあります（Asynchronous Call（<https://developer.4d.com/docs/aikit/asynchronous-call>）を参照）。ただし、この方法はカレントプロセス内でのみ機能します。複数のプロセスにまたがる場合は、代わりにCALL WORKERまたはCALL FORMを使用してください。*
{: .note }

#### 設定の管理

AIの設定を専用のクラスに集約することで、アプリケーション全体からAPIキー、モデルの選択、パラメーターに一貫してアクセスできます。設定はStorage、設定ファイル、セキュアなボールトから読み込むことができ、さまざまなデプロイのシナリオに柔軟に対応できます。

### AI呼び出しとコンテキストの管理

AIを効果的に統合するには、会話のコンテキスト、メッセージ履歴、システムプロンプトを慎重に管理する必要があります。

#### メッセージ履歴の管理

AIモデルは、会話を特定のロール（system、user、assistant）を持つメッセージのコレクションとして処理します。システムメッセージは振る舞いとコンテキストを定め、ユーザーメッセージには質問や指示が含まれ、アシスタントメッセージはAIの応答を表します。メッセージ履歴を保持することで、AIが以前のやり取りを覚えている、文脈に沿った会話が可能になります。

```4d
// Building conversation context
var $messages : Collection
$messages:=New collection

// System message provides context
$messages.push(New object(\
    "role"; "system"; \
    "content"; "You are an assistant analyzing business documents."))

// Add conversation history
For each ($msg; $messageHistory)
    $messages.push(New object(\
        "role"; $msg.role; \
        "content"; $msg.content))
End for each

// Add current user message
$messages.push(New object(\
    "role"; "user"; \
    "content"; $userMessage))

// Call AI with full context
$result:=$aiClient.chat.completions.create(New object(\
    "model"; "gpt-4o-mini"; \
    "messages"; $messages))
```

**注：** *メッセージのロールの違いについては、次のTech Tipで説明しています：Understanding “roles” in AI Conversations（<https://kb.4d.com/assetid=79838>）*
{: .note }

#### プロンプトエンジニアリング

AIの応答の品質は、プロンプトの設計に大きく左右されます。効果的なプロンプトは具体的で、明確な指示と関連するコンテキストを含み、期待する出力形式を指定します。出力形式の要件を明示した構造化されたプロンプトを使用すると、より予測しやすく、扱いやすい結果が得られます。

### エラー処理

堅牢なエラー処理により、AIサービスで問題が発生してもアプリケーションの安定性を保てます。

よくあるエラーのシナリオ：

- 無効または期限切れのキーによるAPI認証の失敗
- APIリクエストに影響するネットワーク接続の問題
- リクエスト量がAPIの割り当てを超えたときのレート制限
- 無効なリクエストパラメーターによるAPIの拒否
- 入力または出力がモデルの上限を超えたときのトークン制限超過エラー

4D AIKitは、APIリクエストが失敗するたびに、構造化されたOpenAIErrorオブジェクトを返します。

例：

```4d
var $client:=cs.AIKit.OpenAI.new("API Key")
var $messages : Collection
var $options : Object
var $result : Object

$messages:=[{role: "user"; content: "How can I use 4D AIKit?"}]

$options:={model: "gpt-4o-mini"; max_tokens: 100}

$result:=$client.chat.completions.create($messages; $options)

If (Not($result.success))
    $error:=$result.errors
    ALERT("Error: "+$error[0].message)
End if
```

## デモ：インテリジェントなビジネスアシスタント

### デモの概要

Demo-AIKitアプリケーションは、インテリジェントな文書管理システムを通じて、AI統合の実践的なパターンを紹介します。このアプリケーションは、ビジョンによる文書の解析、インテリジェントな要約、対話型インターフェースという3つの主要なAI機能を組み合わせています。

#### アプリケーションの機能

- AIによる文書の解析：GPT-4oのビジョン機能を使用して、請求書、領収書、契約書などのビジネス文書から構造化データを自動的に抽出します。
- インテリジェントな要約：さまざまなビジネスニーズに合わせて、複数の種類の要約（簡潔、詳細、エグゼクティブ、要点）を生成します。
- 文書チャットインターフェース：文書の内容について、文脈を完全に踏まえた自然言語での会話ができます。
- 非同期処理：時間のかかるAI処理を、ユーザーインターフェースをブロックせずに実行します。

#### アーキテクチャの構成要素

- DocumentAnalyzer：文書の解析と、ビジョンによるデータ抽出を担当します
- SummaryGenerator：AIによる要約を複数の形式で作成します
- ConversationManager：文書に関するチャットの会話を管理します
- AIConfig：AIの設定と認証情報を一元管理します

#### データベーススキーマ

- Document：アップロードされたファイルを、メタデータと処理ステータスとともに保存します
- ExtractedData：文書から抽出された構造化データを保持します
- Summaries：生成された各種の要約を保持します
- Conversation：チャットのメッセージ履歴と会話の状態を記録します

![図1 - デモのデータベース構造](fig-01)

### AIの設定

アプリケーション全体でAI関連の設定を保持・提供する、設定管理用の共有シングルトンクラスです。APIの認証情報、モデルの選択、デフォルトのパラメーターに関する唯一の情報源として機能します。

AIの処理を行う前に設定が読み込まれるように、AIConfigクラスはアプリケーションの起動時にインスタンス化する必要があります。

On Startupデータベースメソッドに次のコードを追加します：

```4d
// On Startup
var $aiConfig : cs.AIConfig
$aiConfig:=cs.AIConfig.me  // Initialize singleton and load configuration
```

#### 設定の流れ

![図2 - 設定の読み込みワークフロー](fig-02)

#### クラスの実装

**メイン関数**

- shared singleton Class constructor()：シングルトンを初期化し、設定を自動的に読み込みます
- loadConfiguration()：ファイルから設定を読み込むか、設定ダイアログを表示します
- getClient()：設定済みのAIクライアントのインスタンスを返します

**ヘルパー関数**

- _saveToConfigFile()：設定をaiconfig.jsonに保存します
- _loadFromConfigFile()：設定ファイルを読み込んで解析します

#### 設定ダイアログ

![図3 - 設定フォーム](fig-03)

### 文書データの抽出

文書解析モジュールは、GPT-4oのビジョン機能を使用して、テンプレートや定義済みの書式を必要とせずに、さまざまな種類の文書（領収書、請求書など）から構造化された情報を抽出します。

#### 抽出のプロセス

![図4 - 文書解析のワークフロー](fig-04)

#### クラスの実装

**メイン関数**

- analyzeDocument(docID : Text)：メインのエントリーポイントで、パイプライン全体を統括します

**ヘルパー関数**

- _extractGenericData()：ファイルの準備、AIの呼び出し、データの保存を連携させます
- _prepareDocumentFile()：パスの正規化とPDF→PNG変換を行います
- _convertPdfToImage()：pdfiumプラグインを使用して、PDFを144 DPIのPNGに変換します
- _buildExtractionPrompt()：AIに渡すプロンプトを作成します
- _analyzeDocumentWithAI()：ビジョンAPIを呼び出します
- _saveExtractedData()：結果をデータベースに保存します

**注：**

1. *_convertPdfToImageを使用するには、“Keisuke Miyako”が開発した4d-plugin-pdfiumをPluginsフォルダーに追加する必要があります。プラグインは次のリンクからダウンロードできます：<https://github.com/miyako/4d-plugin-pdfium/releases/tag/universal-binary>*
2. *4D 21 R2以降では、AIリクエストでファイルを直接アップロードして使用する機能がネイティブでサポートされています。使い方は次を参照してください：Using PDF Files with 4D AIKit (Purpose="assistants")（<https://kb.4d.com/assetid=79910>）*

#### プロンプトエンジニアリング

文書の解析に使用しているプロンプトは次のとおりです：

```text
あなたは文書を解析しています。見つけられる関連情報をすべて抽出してください：
1. 文書の種類（例：請求書、領収書、契約書、手紙、報告書など）
2. 文書のタイトルまたは件名
3. 文書の日付（形式：YYYY-MM-DD）
4. 主な内容の要約（2～3文）
5. 主要なエンティティ（名前、組織、金額、日付など）
6. この種類の文書に固有のその他の関連フィールド
有効なJSONのみを返してください。抽出できるフィールドはすべて含めてください。
必須キー：documentType, title, documentDate, summary, keyEntities
文書の種類に応じて、その他の関連フィールドを追加してください。
マーカー（```json や ```）は含めないでください。
JSONの前後にテキストを含めないでください。
```

#### プロンプト設計の原則

- 明確な構造：抽出する項目を番号付きリストで示します
- 形式の指定：日付を（YYYY-MM-DD）と指定することで一貫性を確保します
- 柔軟性：「その他の関連フィールド」により、文書の種類に応じた抽出ができます
- ゼロショット学習：例を示さなくても、さまざまな種類の文書に対応できます
- 出力の制約：Markdownや余分なテキストを明示的に禁止します

**なぜ厳しい制約が必要なのか？**

AIモデルは、「抽出したデータは次のとおりです：」のような親切な前置きを付けたり、JSONをjsonブロックで囲んだりしがちです。これらはJSON Parse()の失敗の原因になるため、後処理で対処するのではなく、あらかじめ防ぎます。

#### AIの呼び出し

```4d
Function _analyzeDocumentWithAI($file : 4D.File; $prompt : Text) -> $result : Object

    // Initialize vision helper with document file
    $visionHelper:=This.client.chat.vision.fromFile($file)

    // Configure API parameters
    $params:={\
        model: This.config.visionModel; \    // The used model is “gpt-4o’’
        max_tokens: 1000; \          // Enough for structured data
        temperature: 0.1}             // Low = deterministic extraction

    // Execute vision analysis
    $result:=$visionHelper.prompt($prompt; $params)
    return $result
```

#### 設定

- Temperature 0.1：創造的な応答ではなく、一貫性のある確定的な抽出を保証します
- Max tokens 1000：APIのコストと、複雑な文書にも十分な応答の長さとのバランスを取ります
- ビジョンモデル：文書のスキャンや写真からの、画像とテキストの両方の抽出を処理します

### 要約と分析情報の生成

要約エンジンは、抽出された文書データをもとに、さまざまなビジネスニーズに合わせた視点で要約を作成します。

#### クラスの実装

**メイン関数**

- generateSummary(docID, summaryType)：メインのエントリーポイントで、AIによる文書の要約を生成します

**ヘルパー関数**

- _validateDocumentData()：文書と抽出データが存在することを検証します
- _buildSummaryPrompt()：HTMLの書式指定を含む、種類別のプロンプトを作成します
- _generateWithAI()：AIのチャット補完を呼び出します
- _saveSummary()：生成された要約をデータベースに保存します

#### 要約の種類とプロンプトエンジニアリング

このクラスは4種類の要約をサポートしており、それぞれに専用のプロンプトがあります：

1. 簡潔（2～3文）
    - 重点：最も重要な情報のみ
    - 書式：インラインCSSを使用したシンプルなHTML
2. 詳細（包括的）
    - 重点：構造化されたセクションによる、すべての重要な詳細
    - セクション：文書の概要、主な当事者、重要な日付と金額、注目すべき項目
    - 書式：&lt;h3&gt;、&lt;ul&gt;、&lt;strong&gt;タグを使用したセマンティックなHTML
3. エグゼクティブ（経営層向け）
    - 重点：結論、主要な財務情報、アクション項目
    - 表示：色分けされた優先度バッジ、強調ボックス
    - 書式：重要な項目には青い情報ボックス、優先度の色分け
4. 要点（対応が必要な項目）
    - 重点：対応が必要な項目と優先度
    - 書式：次の要素を含むカード形式のレイアウト：
    - 優先度バッジ（高=#ef4444、中=#f59e0b、低=#10b981）
    - カテゴリータグ（財務/期限/コンプライアンス/一般）
    - 推奨されるアクション

#### 共通のプロンプトパターン

```text
[タスクの説明]

インラインCSSでスタイルを設定した、クリーンなHTMLとして返してください。[具体的な構造]
マーカー（```html や ```）は含めないでください。

文書の情報：[抽出データからのコンテキスト]
```

#### AIの呼び出し

```4d
Function _generateWithAI($prompt : Text)->$result : Object
    var $messages : Collection
    var $params : Object

    $messages:=New collection
    $messages.push(New object("role"; "system"; "content"; "You are a business document analyst."))
    $messages.push(New object("role"; "user"; "content"; $prompt))

    $params:=New object(\
        "model"; This.config.defaultModel; \
        "max_tokens"; This.SUMMARY_MAX_TOKENS; \
        "temperature"; This.SUMMARY_TEMPERATURE)

    $result:=This.client.chat.completions.create($messages; $params)

    return $result
```

**設定**

- システムロール：「あなたはビジネス文書のアナリストです。」：専門的なコンテキストを設定します
- SUMMARY_MAX_TOKENS：800：詳細な要約にも十分な長さです
- SUMMARY_TEMPERATURE：0.3：一貫性と自然な文章とのバランスを取ります

**HTMLのレンダリング**

要約は、セマンティックなタグとインラインCSSを含むクリーンなHTMLとして生成されます。HTMLの出力はWebエリアできれいに表示され、外部のスタイルシートなしでプロフェッショナルな見た目になります。

![図5 - 種類別の要約の例](fig-05)

### AIチャットアシスタント

チャットアシスタントは、選択した文書について、ユーザーがAIに質問できるコンポーネントです。

#### 会話の流れ

![図6 - 会話のワークフロー](fig-06)

#### クラスの実装

**メイン関数**

- sendMessage(docID, userMessage)：メインのエントリーポイントで、選択した文書に関する質疑応答を処理します

**ヘルパー関数**

- _getOrCreateConversation()：既存の会話を取得するか、新しい会話を作成します
- _createNewConversation()：システムコンテキストを設定して会話を初期化します
- _buildSystemMessage()：文書の情報を含むシステムプロンプトを作成します
- _updateConversation()：メッセージ履歴とメタデータを保存します
- _callAI()：会話履歴を渡してAIのチャット補完を呼び出します

#### システムメッセージの作成

システムメッセージは、AIに文書のコンテキストを提供します：

```text
あなたはビジネス文書に関する質問に答える有能なアシスタントです。
次の文書情報を参照できます：
文書：[ファイル名]（種類：[種類]）

抽出データ：
[BuildDocumentContext()による文書の全コンテキスト]

この情報に基づいて質問に答えてください。情報がない場合は、
推測せずにその旨を伝えてください。簡潔かつ丁寧に回答してください。
```

これらの指示はなぜ重要なのでしょうか？

- AIは、特定の文書を扱っていることを認識します
- 抽出されたすべてのデータに最初からアクセスできます
- ハルシネーション<sup>1</sup>を避けるよう明示的に指示されています（「推測せずにその旨を伝えてください」）
- 丁寧な口調が保たれます

例：チャットアシスタントが文書と関係のない質問を受けた場合、AIはモデルがその情報を知っていても回答を断ります。次のように、システムプロンプトで文書に関する質問にのみ答えるよう明確に指示しているためです：

![図7 - 文書と関係のない質問に対するチャットアシスタントの応答例](fig-07)

#### AIの呼び出し

```4d
Function _callAI($history : Collection)->$result : Object
    var $params : Object

    $params:={\
        model: This.config.defaultModel; \
        max_tokens: This.MAX_TOKENS; \
        temperature: This.TEMPERATURE}

    $result:=This.client.chat.completions.create($history; $params)

    return $result
```

**設定**

- MAX_TOKENS：1000：コストを抑えながら、詳しい回答ができます
- TEMPERATURE：0.5：事実の正確さと会話の自然さとのバランスを取ります

<sup>1</sup> **ハルシネーション**（hallucination）とは、生成AIモデルが、検証済みの情報を取得する代わりに、もっともらしく聞こえるものの事実と異なる、意味をなさない、または捏造された情報を生成することです。
{: .footnote }

### 4Dフォームとの統合

DocumentManagerフォームは、よく使われるAI機能を、直感的なコントロールとリアルタイムのフィードバックで統合した、完全なユーザーインターフェースを提供します。

**UIの構成要素：**

- 文書リスト：アップロード、解析、削除の機能を備えたセレクションリスト
- 文書プレビューエリア：文書の内容を表示するWebエリア
- 抽出データパネル：AIが抽出した情報を整形して表示するテキスト。AIが情報をうまく取得できなかった場合に備えて、編集フォームも用意されています
- 要約の表示：HTMLでレンダリングされた要約を表示するWebエリア
- チャットインターフェース：メッセージ履歴を備えた対話型の会話UI

![図8 - ドキュメントマネージャーのインターフェース](fig-08)

![図9 - 抽出データの編集フォーム](fig-09)

#### ユーザーのワークフロー

![図10 - 文書処理のワークフロー：アップロードから解析までのユーザーの操作の流れ](fig-10)

### 導入手順

1. このテクニカルノートに添付されているデモプロジェクトをダウンロードします
2. システム要件：このプロジェクトを4D 20 R9以降で開きます
3. AIKitコンポーネントをインストールします（4D 21のみ）：
    - コンポーネントをプロジェクトのComponentsフォルダーに配置します
    - 注：4D 20 R9にはAIKitがネイティブで含まれているため、この手順は不要です
4. AIの設定を行います：
    - 初回起動時に設定が存在しない場合は、AI設定ダイアログが自動的に表示されます
    - APIキーを入力し、使用するAIプロバイダーの設定を行います
    - 設定がすでに存在する場合は、アプリケーションがドキュメントマネージャーを直接起動します
    - データベースフォルダーにある“aiconfig.json”ファイルを直接編集して、有効な認証情報を設定することもできます
5. アプリケーションを起動します：**ドキュメントマネージャー**フォームを実行してアプリケーションをテストします（設定済みの場合は自動的に起動します）
6. 文書をアップロードします：ビジネス文書やその他の文書をアップロードします（注：プロンプトは、請求書、領収書、契約書などのビジネス文書向けに最適化されています）
7. 文書を解析します：アップロードしたファイルをクリックし、**「選択した文書を解析」**ボタンをクリックします
8. 要約を生成します：要約のセクションを使用して、文書の要約を生成します
9. AIとチャットします：選択した文書について、AIチャットボットとのチャットを開始します

## デプロイ時の考慮事項：

### トークンの使用量とコスト

AIサービスは、トークンの消費量に基づく従量課金制で運用されています。コスト効率のよいデプロイを行うには、トークンの仕組みを理解することが不可欠です。

#### トークンの基本

トークンはテキストの断片を表し、英語ではおよそ4文字、または0.75単語に相当します。入力（プロンプト）と出力（応答）の両方がトークンを消費します。ビジョンモデルでは、テキストのトークンに加えて、画像の解像度に応じた料金がかかります。

#### コスト最適化の戦略

- モデルの選択：日常的なタスクにはgpt-4o-miniを使用し、gpt-4oはビジョンや高度な推論を必要とする複雑な分析に限定します
- プロンプトの最適化：冗長な情報を含めずに、必要なコンテキストを提供する簡潔なプロンプトを作成します
- トークンの上限：maxTokensパラメーターを設定して、予想外に長い応答を防ぎます

#### Demo-AIKitでのモデルの選択

- ビジョン解析：GPT-4o（画像の理解に必要）
- 要約：GPT-4o-mini（テキスト生成のコスト効率がよい）
- チャット：GPT-4o-mini（性能とコストのバランスがよい）

### セキュリティとデータプライバシー

AIの統合には、一般的なアプリケーションのセキュリティに加えて、特有のセキュリティ上の考慮事項があります。

#### APIキーのセキュリティ

- APIキーをソースコードやバージョン管理システムに埋め込まないでください
- キーは、セキュアな設定ファイル、環境変数、または暗号化されたストレージに保存してください
- 開発、テスト、本番の各環境で別々のキーを使用してください

#### データプライバシー

AIサービスに送信されたデータは、ローカル環境の外に出ます。機密情報を処理する際には、GDPRやHIPAAなどの規制要件や、業界固有のコンプライアンスを考慮する必要があります。対策としては、AIで処理する前のデータの匿名化などがあります。

詳しくは次のリンクを参照してください：<https://trust.openai.com/>

#### ファイル処理の制限

Demo-AIKitでは、ビジョン処理のファイルサイズを10MBまでに制限して、処理速度と、ビジネス文書として妥当なサイズとのバランスを取っています。アプリケーションでは、AIで処理する前に、ファイルの種類の検証、マルウェアのスキャン、コンテンツのフィルタリングなどを追加で実装できます。

## トラブルシューティング

よくある問題と解決方法：

| 問題の種類 | 症状 | 解決方法 |
|---|---|---|
| 接続の失敗 | API呼び出しが認証エラーで失敗する | APIキーが有効であることを確認します。キーが期限切れや失効していないか確認し、ネットワークがOpenAIのエンドポイントへのHTTPSリクエストを許可しているか確認します。 |
| トークンの上限超過 | コンテキスト長の超過を示すエラーが発生する | プロンプトのサイズを小さくします。会話履歴を削除します。トークンの上限が大きいモデルに切り替えます。 |
| 処理が遅い | AIの処理に時間がかかりすぎる | ネットワークの遅延を確認します。レート制限による待機が発生していないか確認します。より高速なモデルを使用します。 |
| PDF変換の問題 | PDFファイルの文書解析が失敗する | pdfiumプラグインがインストールされていることを確認します。PDFが有効で保護されていないことを確認します。ディスクの空き容量を確認します。メモリの問題が発生する場合はDPIを下げます。 |
| AIの予期しない応答 | AIが不正確または一貫性のない結果を生成する | プロンプトをより明確にします。temperatureを下げます。出力形式を明示します。抽出データが正しく渡されていることを確認します。 |

## まとめ

4D AIKitは、4Dアプリケーションに人工知能を統合するための、強力なネイティブのソリューションです。主要なAIモデルへのわかりやすいインターフェースを提供することで、開発者は複雑な外部依存やインフラを管理することなく、高度な機能を追加できます。

Demo-AIKitアプリケーションは、ビジョンによる文書の解析、インテリジェントな要約、対話型インターフェースを、まとまりのあるビジネスソリューションとして組み合わせる、実践的な統合パターンを示しています。ここで紹介したクラスベースの構成、非同期処理、設定の一元管理といったアーキテクチャの手法は、さまざまなAI統合のシナリオに応用できるテンプレートとなります。

AI統合を成功させるには、技術的な実装だけでは十分ではありません。モデルの慎重な選択によるコスト意識、パフォーマンスの最適化、堅牢なエラー処理が、本番環境に対応したソリューションを支えます。また、特にAPIキーの管理とデータプライバシーに関するセキュリティ上の考慮事項には、エンタープライズへのデプロイにおいて細心の注意が必要です。

## 関連資料

- 互換性のあるプロバイダー：<https://developer.4d.com/docs/aikit/compatible-openai>
- OpenAIのモデル：<https://platform.openai.com/docs/models>
- Testing 4D AIKit Without an OpenAI API Key：<https://kb.4d.com/assetid=79903>
- 非同期呼び出し：<https://developer.4d.com/docs/aikit/asynchronous-call>
- Understanding “roles” in AI Conversations：<https://kb.4d.com/assetid=79838>
- Pdfiumプラグイン：<https://github.com/miyako/4d-plugin-pdfium/releases/tag/universal-binary>
- Using PDF Files with 4D AIKit (Purpose="assistants")：<https://kb.4d.com/assetid=79910>
