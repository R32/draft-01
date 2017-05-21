package;

/**
top = {
	attrs : {
		names: []                // 包含所有姓名, 如果这个属性不存在, 将使用另内嵌的一个姓名列表
	},
	datas : {
		period_0 : {
			time: timestamp,
			padd: [length=50]    // 补数,

			list: [
				{
					name  : "",
					ctime : timestamp,
					?meta : [],  // 可选, 一些备注
					d1: {        // 数据, 使用单链表形式
						v: Int,
						?a: [],  // 优先于 k 值
						?k: Int, // 如果 a 存在, 则忽略这个
						next: d2
					}
				},
				{}
				{}
			]
		},
		period_1 : {},
		period_2 : {},
		period_3 : {},
	}
};

count: {            // 累加器, 这些数据只存在于运行时
	name_0: []      // 使用固定数组
	name_0: [],
	name_0: [],
	name_0: [],
}


每一次 Save 和 Load 时, 只处理单个的 period_n 对象.
*/
class Data {



}