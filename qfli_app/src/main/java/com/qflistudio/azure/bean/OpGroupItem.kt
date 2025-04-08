data class OpGroupItem(
    var groupNameId: Int,
    var operations: MutableList<OperationItem>,
    var isExpanded: Boolean = false, // false 收起状态  true 展开状态
    var operationsItemClick: ((OperationItem, Int) -> Unit) = { _, _ -> }, // 默认空实现
    var operationsItemLongClick: ((OperationItem, Int) -> Boolean) = { _, _ -> false } // 默认返回 false
)