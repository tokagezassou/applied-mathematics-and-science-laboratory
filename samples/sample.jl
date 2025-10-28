function hello_file()
    open("out/output.txt", "w") do f
        println(f, "Hello File") 
    end
end

function main()
    println("Hello World")
    hello_file()
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end