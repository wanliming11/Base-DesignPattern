//
// Created by Murloc Wan on 2023/2/26.
//

import Foundation

// 概述
// 1. 谈一下对学习代码设计相关知识的重要性的看法。
// 代码设计会更好的体现整体思想，更有利对稳定性，可扩展性，可维护性，可读性，可测试性等方面的考虑。
// 2. 除了本节提到的代码质量评价标准，还有哪些代码质量评价标准？ 读者心中的代码的高质量是上面样子的呢？
// 代码质量评价标准：可维护性，可扩展，可读性，等都是高质量代码的标准，还有的高质量包含 安全，可测试等。
// 3. 如果避免过度设计，读者有哪些体会和经验教训？
// 这个在工作中经常遇到，记得 webview 的业务层使用的中间封装，包括更方便的给上层提供导航栏定制方法，提供容器的处理，
// 设计了过多的继承关系和过多的没有使用的定制功能，导致很难看懂，也给业务的使用带来了困扰。
// 避免的最关键的部分，是了解业务的需求，分清当前的主次，满足核心需求。


// 面向对象编程范式
// 1. UML 觉得太复杂了。
// UML 里面有比较多的连通关系，但是掌握必要的关联关系还是有必要的，但一段时间不使用就忘记了。
// 2. 读者熟悉的语言里面是否支持多继承？
// 并不支持，支持单继承，然后通过协议进行扩展。
// 3. 对于封装，抽象，继承和多态 4个特性，是否语言都支持？
// 都支持，封装显然可以通过函数表达，抽象可以通过协议，隐藏内部实现，继承就是单继承，多态就是继承多态，可以通过子类替换父类。
// 4. 软件设计的自由度很大，不同的人对类的划分，定义，以及类之间的设计，可能都不一样，对于鉴权组件的设计，除了本书的设计思路，还有没有其他设计思路？
// 由于多种鉴权设计，以及可能存在多种鉴权算法，策略模式加上对外提供的抽象的 API， 数据输入和鉴权算法分离，方便后续进行替换。
// 5. UNIX，Linux 为什么是使用 C 语言来开发？
// 首先是性能，最近接底层的效率越高，而且要和设备打交道，底层语言会更高；另外面向对象设计也是一种设计思想，C 语言依然可以通过合理的组织代码结构，变量控制等手段达到比较好的设计。
// 6. 熟悉的编程语言中是否支持接口和抽象类？
// 支持协议接口，但不支持抽象类，但可以通过空函数和类来模拟抽象类。

// 设计原则
// 1. 除了应用类的设计原则上，单一职责原则还能应用到哪些设计方面？
// 其实函数设计，组件设计都需要单一职责原则，因为要保持功能纯粹，方便组合。
// 2. 在学习设计原则的时候，读者要勤于思考，不能仅掌握设计原则的定义，更重要理解设计原则的目的，才能灵活应用设计原则。为什么要"多扩展开放，对修改关闭"？
// 软件设计出来要保证稳定，减少修改才能保证稳定，所以要对修改关闭，但软件不是一层不变的，需要更多功能迭代，所以需要对扩展开放。
// 3. 里氏替换原则存在的意义是什么？
// 任何父类出现的地方，都可以用子类来替换，而不会影响原有的功能。 也就是说，子类可以扩展父类的功能，但不能改变父类原有的功能。如果打破了这个原则，则会导致原有的功能出现错误。
// 4. java.util.concurrent 并发包提供了原子类 AtomicInteger, 其中 getAndIncrement() 给整数加1 ，并且返回未增之前的值。 是否符合单一职责原则？是否符合接口隔离原则？
// 符合单一职责原则，因为只有一个功能，但是不符合接口隔离原则，因为这个接口提供了多个功能，但是不是所有的功能都需要。
// 5. 从本书的 Notification 类的设计看，基于接口而非实际编程， 依赖注入相似，它们之间的区别和联系是什么？
// 依赖注入是通过接口注入，而不是通过实现类注入，这样可以更好的解耦，而且可以通过接口注入不同的实现类，实现不同的功能。
// 6. 如何看待开发中的 重复造轮子 ？
// 重复造轮子是一种浪费，但是有时候也是必要的，因为有时候需要的功能并不是很复杂，但是需要的功能又不是很通用，所以需要自己去实现。
// 7. SOLID, KISS, YAGNI,DRY,LOD 这些的联系与区别？
// SOLID 单一职责，开闭，里氏替换，接口隔离，依赖倒置
// KISS 保持简单，简单，可读性。
// YANGI 你不需要它，不要去实现它，直到你真的需要它。 不要过度设计。
// DRY 不要重复自己，不要重复自己，不要重复自己。
// LOD 低耦合，高内聚，尽量减少类之间的依赖，尽量减少类之间的依赖，尽量减少类之间的依赖。最少知识原则。

// 重构技巧
// 1. 重构代码，遇到了哪些问题？ 吸取了哪些教训？
// 业务开发和重构会同时进行，内部耦合过深，不易拆分； 重构切不可不分析就执行重构，先理解历史代码的关系，然后再处理重构方案才能更好的满足业务，同时要做好覆盖率测试和单元测试。
// 2. 二分查找的辩题算法： 查找递增数组中第一个大于或等于某个给定值的元素，然后为这个算法设计测试用例。
// 测试用例关键想好输入和输出，对期望输出做断言判定。 二分查找的边界问题，需要考虑边界问题，比如数组为空，数组只有一个元素，数组只有两个元素，数组有多个元素，但是没有大于或等于给定值的元素，数组有多个元素，但是有大于或等于给定值的元素。
// * 数组为空或者一个
// * 数组只有两个元素
// * 数组中不存在查找的元素
// 3. 还有哪些解耦方法？
// 各种设计原则，都是为了更好的解耦，依赖注入，接口隔离，单一职责，开闭，里氏替换，依赖倒置。









