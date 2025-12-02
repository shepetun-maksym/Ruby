def bubble_sort(array)

  sorted = false  
  until sorted do
    sorted = true

    (array.length - 1).times do |i|
      if array[i] > array[i + 1]  
        array[i], array[i + 1] = array[i + 1], array[i]  
        
        sorted = false  
      end
    end
  end
  array 
end
puts bubble_sort([7,6,5,4,1,3,2,0])