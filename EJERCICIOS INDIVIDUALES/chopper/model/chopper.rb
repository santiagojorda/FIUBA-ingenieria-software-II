class Chopper
  def chop(value, array)
    return -1 if array == []

    i = 0
    array.each do |element|
      return i if value == element

      i += 1
    end
    -1
  end

  def get_digit_name(number)
    cero = 'cero'
    uno = 'uno'
    dos = 'dos'
    tres = 'tres'
    cuatro = 'cuatro'
    cinco = 'cinco'
    seis = 'seis'
    siete = 'siete'
    ocho = 'ocho'
    nueve = 'nueve'

    nums = [cero, uno, dos, tres, cuatro, cinco, seis, siete, ocho, nueve]
    nums[number]
  end

  def sum(array)
    vacio = 'vacio'
    return vacio if array == []

    sum = 0
    array.each do |element|
      sum += element
    end

    return 'demasiado grande' if sum > 99

    return get_digit_name(sum) if sum < 10

    digits = sum.digits
    result = ''
    digits.each_with_index do |number, index|
      result = get_digit_name(number) + result
      result = ",#{result}" unless index == digits.length - 1
    end
    result
  end
end
