function func1()
	local i = 100  --upvalue
	local func2 = function()
		print(i+1)
	end
	i = 101
	return func2
end

local f = func1()
print(f())	--输出102


function counter()
	local i = 0
	return function() --匿名函数，闭包
		i = i + 1
		return i
	end
end

counter1 = counter()
counter2 = counter() 
-- counter1,counter2 是建立在同一个函数，同一个局部变量的不同实例上面的两个不同的闭包
--                   闭包中的upvalue各自独立，调用一次counter()就会产生一个新的闭包
print(counter1()) -- 输出1
print(counter1()) -- 输出2
print(counter2()) -- 输出1
print(counter2()) -- 输出2


function shareVar(n)
	local function func1()
		print(n)
	end
	
	local function func2()
		n = n + 10
		print(n)
	end
	return func1,func2
end

local f1,f2 = shareVar(1024) --创建闭包，f1,f2两个闭包共享同一份upvalue

f1() -- 输出1024
f2() -- 输出1034
f1() -- 输出1034
f2() -- 输出1044

--- 利用闭包实现iterator,iterator是一个工厂，每次调用都会产生一个新的闭包,该闭包内部包括了upvalue(t,i,n)
--- 因此每调用一次该函数都会产生闭包，那么该闭包就会根据记录上一次的状态，以及返回table中的下一个元素
function iterator(t)
	local i = 0
	local n = #t
	return function()
		i = i + 1
		if i <= n then
			return t[i]
		end
	end
end

testTable = {1,2,3,"a","b"}

-- while中使用迭代器
iter1 = iterator(testTable) --调用迭代器产生一个闭包
while true do
	local element = iter1()
	if nil == element then
		break;
	end
	print(element)
end

-- for中使用迭代器
for element in iterator(testTable) do --- 这里的iterator()工厂函数只会被调用一次产生一个闭包函数，后面的每一次迭代都是用该闭包函数，而不是工厂函数
	print(element)
end