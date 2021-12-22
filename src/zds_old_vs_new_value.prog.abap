*&---------------------------------------------------------------------*
*& Report zds_old_vs_new_value
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zds_old_vs_new_value.

data: begin of animal,
        category type string,
        species  type sorted table of string
                      with unique key table_line,
      end of animal,
      animals_old like sorted table of animal
                  with unique key category,
      animals_new like sorted table of animal
                  with unique key category.

**********************************************************************
* Old
**********************************************************************
animal-category = `Herbivore`.
insert `Cow`   into table animal-species.
insert `Horse` into table animal-species.
insert `Sheep` into table animal-species.
insert animal  into table animals_old.
clear animal.
animal-category = `Carnivore`.
insert `Tiger`  into table animal-species.
insert `Lion`   into table animal-species.
insert animal   into table animals_old.
clear animal.
animal-category = `Omnivore`.
insert `Rat`  into table animal-species.
insert `Bear` into table animal-species.
insert `Pig`  into table animal-species.
insert `Ape`  into table animal-species.
insert animal into table animals_old.

**********************************************************************
* New
**********************************************************************
animals_new = value #(
  ( category = `Herbivore`
    species  = value #( ( `Cow`   )
                        ( `Horse` )
                        ( `Sheep` ) ) )
  ( category = `Carnivore`
    species  = value #( ( `Tiger` )
                        ( `Lion`  ) ) )
  ( category = `Omnivore`
    species  = value #( ( `Rat`  )
                        ( `Bear` )
                        ( `Pig`  )
                        ( `Ape`  ) ) ) ).
assert animals_old = animals_new.
