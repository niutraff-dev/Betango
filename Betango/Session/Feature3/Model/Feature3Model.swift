import Foundation

// MARK: - Player Model
struct Dictionary: Codable, Equatable, Identifiable {
    let id: Int
    let title: String
    let subtitle: String
    let info: String

    init(
        id: Int,
        title: String,
        subtitle: String,
        info: String
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.info = info
    }
}

extension Dictionary {
    static let type1 = Dictionary(
        id: 1,
        title: "Lento",
        subtitle: "Slow, stretched, and full of pauses",
        info: "A very slow tango tempo where every movement is deeply felt and clearly articulated. Lento allows dancers to focus on balance, axis, and the quality of the embrace. It leaves plenty of space for pauses, musical phrasing, and subtle embellishments. Often used with dramatic, emotional orchestras."
    )

    static let type2 = Dictionary(
        id: 2,
        title: "Andante",
        subtitle: "Calm, walking, and comfortable",
        info: "One of the most common and comfortable tango tempos. The movement feels natural and unhurried, closely connected to the walking pulse of the music. Andante is ideal for social dancing and learning, as it supports smooth transitions, clear direction, and musical awareness."
    )

    static let type3 = Dictionary(
        id: 3,
        title: "Moderato",
        subtitle: "Balanced and confident",
        info: "A moderate tempo that combines stability with energy. It allows dancers to alternate between smooth and sharp movements, play with accents, and explore rhythmic variations. Moderato is well suited for more complex combinations while maintaining control and musicality."
    )

    static let type4 = Dictionary(
        id: 4,
        title: "Allegro",
        subtitle: "Fast, lively, and rhythmic",
        info: "A fast tango tempo with a strong rhythmic drive. It requires solid technique, precise footwork, and quick reactions. In Allegro there are fewer long pauses and more continuous movement, emphasizing energy and rhythmic clarity. Common in lively milongas and rhythmic orchestras."
    )

    static let type5 = Dictionary(
        id: 5,
        title: "Muy Rápido",
        subtitle: "Very fast and intense",
        info: "An extremely fast tempo, close in feeling to milonga. The dance becomes compact, efficient, and highly rhythmic. Small steps, excellent coordination, and a strong sense of pulse are essential. This tempo is generally suited for advanced dancers."
    )

    static let type6 = Dictionary(
        id: 6,
        title: "Ocho",
        subtitle: "Figure-eight movement with rotation",
        info: "A fundamental tango movement based on pivots and rotation. The dancer steps forward or backward while turning on one foot, creating a figure-eight pattern. Ochos develop balance, dissociation, and control of the axis, and they are essential for musical interpretation and flow in tango."
    )

    static let type7 = Dictionary(
        id: 7,
        title: "Side Step",
        subtitle: "Lateral movement for space and balance",
        info: "A step taken directly to the side, often used to create space, reset alignment, or change direction. Side steps help maintain balance in the embrace and are frequently used as transitional or preparatory movements within combinations."
    )

    static let type8 = Dictionary(
        id: 8,
        title: "Giro",
        subtitle: "Circular movement around the partner",
        info: "A rotational figure where one dancer moves in a circle around the other using a sequence of steps (side, forward, back). Giros require precise technique, stable axis, and clear lead and follow. They are commonly used to add dynamism and spatial variation to the dance."
    )

    static let type9 = Dictionary(
        id: 9,
        title: "Cruzada",
        subtitle: "Crossed step for structure and pause",
        info: "Crossing the free leg in front of the supporting leg creates a stable and characteristic tango shape. This position is often used as a pause, musical accent, or moment of dynamic change."
    )

    static let type10 = Dictionary(
        id: 10,
        title: "Sacada",
        subtitle: "Displacement through shared space",
        info: "Stepping into the partner’s space causes a natural displacement of their leg. This element requires precise timing, a stable axis, and clear partner communication."
    )

    static let type11 = Dictionary(
        id: 11,
        title: "Parada",
        subtitle: "Stop with invitation",
        info: "A controlled stop highlights the follower’s leg movement and creates an opportunity for a pause or decorative response, enhancing expressiveness."
    )

    static let type12 = Dictionary(
        id: 12,
        title: "Barrida",
        subtitle: "Sweeping leg guidance",
        info: "A smooth sweeping action along the floor guides the partner’s leg while maintaining continuous contact, emphasizing fluidity."
    )

    static let type13 = Dictionary(
        id: 13,
        title: "Boleo",
        subtitle: "Whipping free-leg motion",
        info: "A sudden change in torso rotation creates a dynamic whipping motion of the free leg, used as an expressive rhythmic accent."
    )
    
    static let type14 = Dictionary(
        id: 14,
        title: "Gancho",
        subtitle: "Sharp accented hook",
        info: "A sharp and dynamic leg hook is executed with strong accentuation and is common in rhythmic and stage tango."
    )
    
    static let type15 = Dictionary(
        id: 15,
        title: "Media Luna",
        subtitle: "Half-moon directional change",
        info: "A half-circular movement path allows for a smooth change of direction and prepares subsequent rotations."
    )
    
    static let type16 = Dictionary(
        id: 16,
        title: "Molinete",
        subtitle: "Circular movement around partner",
        info: "A sequence of steps around the partner creates continuous rotational movement and often serves as the basis for giros."
    )
    
    static let type17 = Dictionary(
        id: 17,
        title: "Pivot",
        subtitle: "Rotation on a single foot",
        info: "Rotation of the torso and foot on the supporting leg forms the basis of many tango elements and allows changes in direction and dynamics."
    )
    
    static let type18 = Dictionary(
        id: 18,
        title: "Rebound",
        subtitle: "Elastic rebound",
        info: "An elastic change of direction highlights rhythm and musical accents, adding energy to the movement."
    )
    
    static let type19 = Dictionary(
        id: 19,
        title: "Colgada",
        subtitle: "Outward off-axis movement",
        info: "Leaning outward from the shared axis creates a sense of stretch and dynamic balance between partners."
    )
    
    static let type20 = Dictionary(
        id: 20,
        title: "Volcada",
        subtitle: "Inward off-axis movement",
        info: "Leaning inward toward the partner creates a strong visual line and requires precise support and trust."
    )
    
    static let type21 = Dictionary(
        id: 21,
        title: "Abrazo",
        subtitle: "Embrace as communication",
        info: "The shape of the embrace defines how lead, balance, and movement quality are communicated in tango."
    )
    
    static let type22 = Dictionary(
        id: 22,
        title: "Caminata",
        subtitle: "Fundamental tango walk",
        info: "The quality of the walk reflects the dancer’s axis, balance, and musicality and is considered the foundation of tango."
    )
    
    static let type23 = Dictionary(
        id: 23,
        title: "Lead",
        subtitle: "Movement intention",
        info: "Clearly communicated movement intention allows the partner to accurately perceive direction and quality."
    )
    
    static let type24 = Dictionary(
        id: 24,
        title: "Adorno",
        subtitle: "Decorative expression",
        info: "Decorative movements complement basic steps and allow personal style and musical interpretation."
    )
    
    static let type25 = Dictionary(
        id: 25,
        title: "Pause",
        subtitle: "Intentional stillness",
        info: "A moment of stillness enhances musical tension and highlights expressive moments."
    )
}
