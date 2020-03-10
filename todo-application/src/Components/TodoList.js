import React, { Component } from 'react'
import TodoItem from './TodoItem'
export default class TodoList extends Component {
    
    render() {
        const{ items,clearLists, deleteTask, editTask }=this.props
        return (
            <ul className="list-group my-5">
                <h3 className="text-capitalize text-center">
                    todo list
                </h3>
                {items.map(item=>{
                    return <TodoItem 
                    key={item.id} 
                    title={item.title}
                    deleteTask={()=>deleteTask(item.id)} // arrow function retuns the function to allow calling of the deleteTask method
                    editTask={()=>editTask(item.id)}
                    />;
                })}
                <button
                    type="button"
                    className="btn btn-danger btn-block text=capitalize
                    mt-5"
                    onClick={clearLists}
                    >
                        Clear List
                </button>
            </ul>
        );
    }
}
