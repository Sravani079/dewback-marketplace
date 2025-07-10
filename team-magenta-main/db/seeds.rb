Dewback.create!([
  {
    title: "Scout Dewback",
    color: "Green",
    size: "Small",
    max_speed: "Slow",
    max_load: "Light",
    food_requirements: "Low",
    price: 200,
    quantity: 5,
    description: "A small green Dewback ideal for short patrols.",
    image: "dewback1.jpg"
  },
  {
    title: "Cargo Dewback",
    color: "Brown",
    size: "Medium",
    max_speed: "Moderate",
    max_load: "Light",
    food_requirements: "Moderate",
    price: 250,
    quantity: 3,
    description: "A sturdy medium-sized Dewback.",
    image: "dewback2.jpeg"
  },
  {
    title: "Tatooine Pack Dewback",
    color: "Sandy Green",
    size: "Large",
    max_speed: "Moderate",
    max_load: "Heavy",
    food_requirements: "High",
    price: 300,
    quantity: 4,
    description: "Reliable desert beast of burden equipped for sandtrooper patrols across the dunes of Tatooine.",
    image: "DewbackSandtrooper.jpg"
  },
  {
    title: "Elite Stormtrooper Dewback",
    color: "White",
    size: "Large",
    max_speed: "Fast",
    max_load: "Moderate",
    food_requirements: "Moderate",
    price: 320,
    quantity: 5,
    description: "Special forces Dewback used for elite patrol missions under stormtrooper command.",
    image: "dewback4.jpg"
  },
  {
    title: "Rugged Wilderness Dewback",
    color: "Earth Brown",
    size: "Extra Large",
    max_speed: "Slow",
    max_load: "Extreme",
    food_requirements: "Very High",
    price: 550,
    quantity: 2,
    description: "A heavily-armored wilderness Dewback with thick scales and fur, built for survival in the harshest climates of the Outer Rim.",
    image: "Dewback-CGSWG.webp"
  },
  {
    title: "Jabba's Royal Dewback",
    color: "Swamp Green",
    size: "Extra Large",
    max_speed: "Slow",
    max_load: "Heavy",
    food_requirements: "High",
    price: 500,
    quantity: 1,
    description: "A lavish, slow-moving Dewback bred for Jabba the Hutt. Prioritizes comfort and intimidation over speed.",
    image: "dewback.webp"
  }
])


User.create!(
  name: 'Default Admin',
  email: 'admin@example.com',
  password: 'password',
  admin: true
)
