shader_type canvas_item;

// Цвет, который нужно заменить (серый цвет тела кота)
// RGB(96, 96, 112) в нормализованном виде: 96/255 ≈ 0.376, 112/255 ≈ 0.439
uniform vec4 target_color : source_color = vec4(0.376, 0.376, 0.439, 1.0);

// Новый цвет, на который заменяем
uniform vec4 replacement_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);

// Допуск для поиска цвета (0.0 - точное совпадение, 1.0 - любой цвет)
uniform float tolerance : hint_range(0.0, 1.0) = 0.05;

void fragment() {
    // Получаем оригинальный цвет пикселя
    vec4 original_color = texture(TEXTURE, UV);
    
    // Вычисляем расстояние между цветами в цветовом пространстве RGB
    float distance = length(original_color.rgb - target_color.rgb);
    
    // Если пиксель прозрачный, делаем его полностью прозрачным
    if (original_color.a < 0.01) {
        COLOR = vec4(0.0, 0.0, 0.0, 0.0);
    }
    // Если цвет близок к target_color, заменяем его
    else if (distance < tolerance) {
        // Сохраняем оригинальную прозрачность пикселя
        COLOR = vec4(replacement_color.rgb, original_color.a);
    }
    // Иначе оставляем оригинальный цвет без изменений
    else {
        COLOR = original_color;
    }
}