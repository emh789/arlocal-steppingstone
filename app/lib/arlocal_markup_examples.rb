module ArlocalMarkupExamples


  module_function


  def examples
    [ example_0, example_1, example_2, example_3, example_4 ]
  end


  def example_0
    'Title of Song'
  end


  def example_1
    'Lyric sheet from *My Best Song*.'
  end


  def example_2
    "© 1999, All Rights Reserved.\n\nThanks to everyone who participated!"
  end


  def example_3
<<EXAMPLE_3
Vocals: Singer Chanson
Piano: Keys Forte
Drumms: Paddy Membrane
EXAMPLE_3
  end

  def example_4
<<EXAMPLE_4
  # Heading

  ## Subheading

  Evil gummy bears destroy forest. **Face.** _Gummy bears don't fool around._ ***All cows eat grass.***  Evil gummy bears destroy forest. **Face.** _Gummy bears don't fool around._ ***All cows eat grass.***

  1. All
  2. Cows
  3. Eat
  4. Grass

  > "Elephants and donkeys got big ears."

  ---

  [Back to overview](/admin/welcome/markup_types)
EXAMPLE_4
  end


end
