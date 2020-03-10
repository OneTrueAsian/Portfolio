import React, { Component } from 'react'
import TodoInput from './Components/TodoInput';
import TodoList from './Components/TodoList';
import 'bootstrap/dist/css/bootstrap.min.css';
import uuid from 'uuid' // creates a unique id


class App extends Component {
  state = {
    items: [],
    id: uuid(), // id for item created
    item: "",
    editEvent: false // boolean to edit or not
  };

  HandleInput = e => {
    this.setState({
      item: e.target.value
    });
  };

  HandleSubmit = e => {
    e.preventDefault();
    
    const newItem = {
      id: this.state.id,
      title: this.state.item
    };
    const updatedItems = [...this.state.items, newItem]; // splits array into the items
    this.setState({
      items: updatedItems, // set items to updated items
      item: "", // set item back to empty string
      id: uuid(), // sets id to unique id
      editEvent: false
    });

  };

  clearList = () => {
    this.setState({
      items: []
    });
  };

  

  deleteTask = (id) =>{
    const sortedItems = this.state.items.filter( // use prop drilling to sort items in todoList
      item => item.id !==id)
      this.setState({
        items:sortedItems
      });
  };

  editTask = id => {
    const sortedItems = this.state.items.filter( // use prop drilling to sort items in todoList
      item => item.id !==id)

    const selectItem = this.state.items.find( // find id of the item searchign for
      item=> item.id === id)

    this.setState({ // set state of the edited item with the new data entered
      items: sortedItems,
      item: selectItem.title,
      editEvent: true,
      id:id
    });

    (this.editEvent ? console.log("edit event is true",this.items): console.log("did not change"))
  }

  render() {
    return (
      <div className="container">
        <div className="Row">
          <div className="col-10 mx-auto col-md-8 mt-4" >
          <h3 className="text-captalize text-center">
            Todo App
          </h3>
          <TodoInput 
            item={this.state.item} // items passed into todo input
            HandleInput={this.HandleInput}
            HandleSubmit={this.HandleSubmit}
            HandleEdit={this.state.editTask}
            />
          <TodoList items={this.state.items} 
            clearLists={this.clearList}
            deleteTask={this.deleteTask}
            editTask={this.editTask}/>
          </div>
        </div>
      </div>
    );
  };
};


export default App;
