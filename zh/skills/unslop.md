> 翻译自 `skills/unslop/SKILL.md`。本译文仅供人阅读，Agent 执行时读英文原文。术语见 [GLOSSARY.md](../GLOSSARY.md)。

---

## Unslop（去 AI 腔）`unslop`（技能）

编辑文本以移除 AI 模式。扫描下列模式，然后重写。保住含义，匹配预期语气。

> 译注：规则编号是稳定 id，被其他技能引用。规则 13/14 涉及英文标点，中文写作不适用原文约束（详见《失效与误导条款清单》），但保留原文以完整呈现技能全貌。各条末尾括注为中文写作的对应建议。

### 内容

3. **表层 `-ing` 短语。** "highlighting..."、"ensuring..."、"reflecting..."、"showcasing..."、"fostering..."。删除，或用真实来源展开。（中文对应：空泛的"旨在……""致力于……"）
5. **模糊归因。** "Experts believe"、"Industry reports suggest"、"Some critics argue"。点名来源或删除。（中文对应："专家认为""有分析指出"）

### 语言

7. **AI 词汇。** Additionally, crucial, delve, enduring, enhance, fostering, garner, interplay, intricate, landscape（抽象义）, pivotal, showcase, tapestry（抽象义）, testament, underscore, vibrant。换平实词。（中文对应：赋能、抓手、闭环、沉淀、打通、颗粒度等黑话）
8. **花式说"is"。** "serves as"、"stands as"、"boasts"、"features"。直接说 "is" 或 "has"。
9. **"不仅是 X，更是 Y。"** 直接陈述要点。
10. **三段式强迫症。** 不要硬凑三个一组。用自然数量。
11. **同义词轮换。** 同一段里 protagonist、main character、central figure、hero 换着用。选一个，重复它。
12. **虚假区间。** "from X to Y" 而 X、Y 不在有意义刻度上。直接列条目。

### 风格

13. **Em dash 滥用。** 完全避免 em dash。只用句号或逗号（不用括号、en dash、连字符替代）。需要分隔就结束句子或用逗号。
14. **冒号滥用。** 列表或示例前的冒号可以；句中连接符不行。"If you're coming from traditional automation: instead of..."这种冒号不增加任何信息。重写让要点自立。
15. **粗体滥用。** 不要每个专有名词或缩写都加粗。
16. **行内标题式列表。** 标志是加粗标签加冒号复述本行："**Performance:** Performance improved..."。改成散文。以句号结尾、点名字目、后接真新信息的加粗引子（"**Schema in TypeScript.** Tables live in one file."）没问题，不是标志。
17. **标题 Title Case。** 用 sentence case。
18. **装饰性 emoji。** 从标题与要点移除。
19. **弯引号。** 用直引号。

### 对话腔

20. **聊天机器人短语。** "I hope this helps!"、"Let me know if..."、"Of course!"、"Certainly!"、"Found the smoking gun!"。删除。
22. **谄媚语气。** "Great question! You're absolutely right!"。直接回应。

### 填充

23. **填充短语。** "In order to" 改 "To"。"Due to the fact that" 改 "Because"。删 "It is important to note that"。（中文对应："值得注意的是""众所周知"）
24. **过度对冲。** "could potentially possibly be argued that it might" 改 "may"。
25. **泛泛结论。** "The future looks bright."。陈述具体计划或事实。

### 行话

26. **抽象隐喻名词。** Substrate（→base）、wedge、wedge in（→add）、vector（→way, method）、locus、vantage、nexus、作名词的 primitive、作隐喻的 harness、"API surface" 的 surface、bedrock、作隐喻的 scaffolding、modality、paradigm、gold-plating（超过工作所需的镀金）、作隐喻的 ratchet（写机制真名，或"只会收紧的限制"）、evacuate 移动代码（→move out）、endgame（→最后阶段）、north star、flywheel。这些读起来很技术，但几乎都有更平实的具体词。选具体的词。

### 平实言语

27. **说它做什么，不说它感觉如何。** "the database stays close at hand"、"SQL you can read"、"types that follow your schema" 命名的是一种感觉。修复是命名机制或数字："`.toSQL()` 返回发给数据库的精确字符串"、"重命名一列会让构建失败"。问这句想让读者做什么或知道什么，然后写那个。无法改写成具体指令、事实或数字就砍。多一个检查：这句话若能原样出现在另一个项目的文档里，它对本项目就什么都没说。砍。
28. **压缩或拆分密句。** 读者要回读才能解析的句子，断成两句或去掉从句。一句一个想法。
29. **主动语态。** 优先。"is/are/was/were + 过去分词"要抓出来并点名行动者："queries are validated" → "the compiler validates queries"；"the file is parsed by the loader" → "the loader parses the file"。行动者未知或确实无关紧要时被动可以。
30. **砍副词，或换更强的动词。** "runs quickly" → "is fast" 或那个数字；"significantly improves" → 实测差值。副词撑着弱动词，说明动词选错了。
31. **优先平实词。** "utilize"、"leverage" → "use"；"facilitate" → "help"；"numerous" → "many"；"in the event that" → "if"。花哨的同义词很少更清楚。
32. **做作的散文。** 有字面短语却用隐喻或花腔：格言式表达（"wire it or delete it"）、修辞性残句、拟人化代码（"the plan holds it"）、比喻性动词（"rides along"、"stands on"）、套话框架。"A dial worth turning" → "a parameter worth varying"。说你的意思。规则 26 覆盖隐喻名词。
33. **过度压缩。** 掉冠词、无动词残句、符号腔、逼读者解码而非阅读的缩写。"Parser rejects bad date → exit 2, no write" → "The parser rejects a bad date, exits with code 2, and writes nothing."。写带冠词与动词的完整句子，箭头与缩写展开写。

---
