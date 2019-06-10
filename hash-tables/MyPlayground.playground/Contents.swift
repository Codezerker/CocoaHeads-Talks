// Constants and Auxiliary Hash Function

let m = 8
let k = 12

func _h(_ k: Int) -> Int
{
    return k % m
}

// Linear Probing

func h_l(_ k: Int, _ i: Int) -> Int
{
    return (_h(k) + i) % m
}

for i in 0...(m - 1)
{
    h_l(k, i)
}

// Quadratic probing:
//   h(k, i) = (h'(k) + c1 * i + c2 * i^2) mod m
//   where c1 = 1/2, c2 = 1/2 and m is power of 2

func h_q(_ k: Int, _ i: Int) -> Int
{
    // assert(is_pow_of_2(m))
    return (_h(k) + Int(Float(i)/2 + Float(i*i)/2)) % m
}

for i in 0...(m - 1)
{
    h_q(k, i)
}
