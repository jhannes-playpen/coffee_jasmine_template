calculateSum = (values...) ->
  sum = 0
  console.log(values)
  sum += value for value in values
  sum
  
exports.calculateSum = calculateSum
