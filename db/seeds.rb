# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

data = {
  host: 'SoundCloud',
  title: 'Competition',
  intro: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam volutpat leo vitae leo rutrum ullamcorper. Maecenas in orci nulla. Aenean gravida adipiscing arcu at sodales.',
  description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam volutpat leo vitae leo rutrum ullamcorper. Maecenas in orci nulla. Aenean gravida adipiscing arcu at sodales. Donec nisl lacus, gravida sit amet aliquam vitae, pulvinar at sapien. Nullam congue convallis libero, ut luctus erat posuere eu. Fusce sit amet ante nisi, ac viverra ligula. Etiam vel velit tellus. Phasellus pharetra, ligula fermentum interdum lobortis, lorem arcu pulvinar urna, vel blandit augue augue pulvinar elit. Duis nec justo ut mi sollicitudin eleifend sed sit amet leo. Quisque aliquet quam eget tortor tincidunt malesuada. Vivamus at neque ut sem molestie vulputate ac id diam. Fusce ut pulvinar leo. Curabitur sit amet dui ut nulla venenatis pretium ac vel dolor. Aliquam id imperdiet arcu. Vestibulum molestie venenatis tellus, sed lobortis nisi sodales ac.',
  prizes: '* Prize 1',
  about: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam volutpat leo vitae leo rutrum ullamcorper. Maecenas in orci nulla. Aenean gravida adipiscing arcu at sodales.',
  #group: '',
  #rules: '',
  #download: '',
  start_date: Time.now,
  end_date: Time.now + 30.days
}

Competition.create(data)

puts "Competition, fuck yeh."
