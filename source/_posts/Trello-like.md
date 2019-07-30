---
title: 类Trello拖拽需求实现过程
tags:
  - React
  - react-beautiful-dnd
date:
categories:
  - 技术
---

使用 react-beautiful-dnd 类库，实现类Trello 拖拽效果，license Apache 2.0

<!-- more -->
### 三个主要元素

- DragDropContext - 拖拽的画布区域
- Droppable - 可拖拽节点的容器高阶组件定义
- Draggable - 可拖拽节点高阶组件

![](https://user-images.githubusercontent.com/2182637/53614150-efbed780-3c2c-11e9-9204-a5d2e746faca.gif)

### 基础的数据结构定义

1. 列表顺序 - eg: [1,2,3]
2. 节点map - {1: [{node11},{node12}], 2: [{node21}, {node22}]}

### 基础的节点定义

1. 定义画布区域

        <DragDropContext onDragEnd={this.onDragEnd.bind(this)}>
        	{...}
        </DragDropContext>

2. 定义容器组件

        <Droppable droppableId="board" type="COLUMN" direction="horizontal">{...}</Droppable>

3. 定义可拖拽节点

        <Droppable droppableId="board" type="COLUMN" direction="horizontal">
          {provided => (
            <div ref={provided.innerRef} {...provided.droppableProps}>
              {list.map((grp, grpIndex) => {
                <Draggable draggableId={grp.id} index={grpIndex} key={grp.id}>
                  {(provided, snapshot) => (
                    <div
                      ref={provided.innerRef}
                      isDragging={snapshot.isDragging}
                      {...provided.draggableProps}
                      {...provided.dragHandleProps}
                    >
                      {content}
                    </div>
                  )}
                </Draggable>;
              })}
            </div>
          )}
        </Droppable>


### 数据处理过程

- onDragEnd
```javascript
function onDragEnd(result) {
    if (!result.destination) {
      return;
    }

    const source = result.source;
    const destination = result.destination;
    if (
      source.droppableId === destination.droppableId &&
      source.index === destination.index
    ) {
      return;
    }
    const { colOrdered, originCols } = this.state;
    // type 区分当前是拖拽的「节点」还是「列」
    if (result.type === 'COLUMN') {
      const colOrdered = reorderCol(
        this.state.colOrdered,
        source.index,
        destination.index
      );
      this.setState({
        colOrdered
      });
      return;
    }

    const data = reorderMap({
      colMap: this.state.colMap,
      source,
      destination
    });

    const finalIndex = getOriginDesIndex(
      destination.index,
      this.state.colMap[destination.droppableId],
      this.state.originColMap[destination.droppableId]
    );
    const params = {
      position: calculateNewPosition(
        finalIndex,
        this.state.originColMap[destination.droppableId]
      )
    };
    if (source.droppableId !== destination.droppableId) {
      params['group_id'] = parseInt(destination.droppableId.split('-')[1], 10);
    }
    this.setState({
      colMap: data
    });
  }
```

- reorderCol
```javascript
  function reorderCol() {
    const result = Array.from(list);
    const [removed] = result.splice(startIndex, 1);
    result.splice(endIndex, 0, removed);
    return result;
  }
```

- reorderMap
```javascript
  function reorderMap({colMap, source, destination}) {
    const current = [...colMap[source.droppableId]];
    const next = [...colMap[destination.droppableId]];
    const target = current[source.index];

    // moving to same list
    if (source.droppableId === destination.droppableId) {
      const reordered = reorderCol(
        current,
        source.index,
        destination.index,
      );
      const result = {
        ...colMap,
        [source.droppableId]: reordered,
      };
      return {
        colMap: result,
      };
    }

    // moving to different list

    // remove from original
    current.splice(source.index, 1);
    // insert into next
    next.splice(destination.index, 0, target);

    const result = {
      ...colMap,
      [source.droppableId]: current,
      [destination.droppableId]: next,
    };
    return {
      colMap: result,
    };
  }
```