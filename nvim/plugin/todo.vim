" TODO.VIM: A simple todo plugin
" Author: evvive <flexevvive@gmail,com>

if !exists("g:todo_list") || type(g:todo_list) != type({})
    let g:todo_list = {}
endif

function ListTodo()
    if !empty(g:todo_list)
        echo "*** TODO.VIM ***"
        for g:todo in keys(g:todo_list)
            " echo g:todo . ": " . g:todo_list[g:todo] . ";"
            lua require("notify")(vim.g.todo .. ": " .. vim.g.todo_list[vim.g.todo])
        endfor
    else
        echo "*** TODO.VIM ***"
        echo "Empty todo list!"
    endif

    return
endfunction

function AddTodo()
    let new_todo = input("add_todo>")
    let name = input("short_name>")

    if exists("g:todo_list[name]")
        echoerr "Invalid todo short name, already exists"

        return
    endif

    let g:todo_list[name] = new_todo

    return
endfunction

function RemoveTodo()
    while 1
        let todo = input("remove_todo>")

        if exists("g:todo_list[todo]")
            break
        endif

        echo "Invalid todo, try again"
    endwhile

    let g:todo_list = remove(g:todo_list, todo)
    echo "Succesfuly removed " . todo . " from your todo list"

    return
endfunction
