import React, { Component } from 'react'

export default class TodoInput extends Component {
    render() {
        const {item, HandleInput,HandleSubmit, HandleEdit}=this.props;
        return <div className="card card-body my=3">
            <form onSubmit={HandleSubmit}>
                <div className="input-group">
                    <div className="input-group-prepend">
                        <div className="input-group-text bg-primary text-white">
                        <i className="fas fa-book"></i>
                        </div>
                    </div>
                    <input type="text" 
                        className="form-control text-capitalize"
                        placeholder="Add An Item"
                        value={item}
                        onChange={HandleInput}
                    />
                </div>
                <button type="Submit"
                    className="btn btn-block btn-primary mt-3">
                    {HandleEdit ? "Edit Item":"Add Item"}
                </button>
            </form>
        </div>
        
    }
}
