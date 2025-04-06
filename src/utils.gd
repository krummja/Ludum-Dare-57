class_name Utils


# Linearly interpolate between floats `a` and `b` over interval `t`.
static func lerp_float(a: float, b: float, t: float) -> float:
    return a * (1 - t) + b * t


static func lerp_color(a: Color, b: Color, t: float) -> Color:
    var new_r = Utils.lerp_float(a.r, b.r, t)
    var new_g = Utils.lerp_float(a.g, b.g, t)
    var new_b = Utils.lerp_float(a.b, b.b, t)
    return Color(new_r, new_g, new_b)
