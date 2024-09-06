# tests for generate_key_string, letter_units and shift_n_units

test_that('generate_key_string correctly computes the key string when the
          message is imperialcollege and the keyword is MATRIX, as given in
          the brief', {
  expect_equal(generate_key_string('imperialcollege', 'MATRIX'), 'MATRIXMATRIXMAT')
})

test_that('letter_units correctly computes the letter units of A', {
  expect_equal(letter_units('A'), 0)
})

test_that('shift_n_units correctly computes A shifted by 1 unit', {
  expect_equal(shift_n_units('A', 1), 'B')
})

# tests for vigencrypt and vigdecrypt

test_that('vigencrypt correctly encrypts the message imperialcollege with
          keyword of MATRIX, as given in the brief', {
  expect_equal(vigencrypt('imperialcollege', 'MATRIX'), 'UMIVZFMLVFTIQGX')
})

test_that('vigdecrypt correctly decrypts the message UMIVZFMLVFTIQGX with
        keyword of MATRIX, as given in the brief', {
  expect_equal(vigdecrypt('UMIVZFMLVFTIQGX', 'MATRIX'), 'imperialcollege')
})

test_that('supplying a message and a keyword to vigencrypt in oppisite cases
        to those indicated in the brief rasies an error', {
  expect_error(vigencrypt('IMPERIALCOLLEGE', 'matrix'), 'Invalid message, Invalid key')
})

test_that('supplying a message and a keyword to vigdecrypt in oppisite cases
        to those indicated in the brief rasies an error', {
  expect_error(vigdecrypt('umivzfmlvftiqgx', 'matrix'), 'Invalid message, Invalid key')
})

test_that('supplying a message to vigencrypt containing non-alphabetic
          characters rasies an error', {
  expect_error(vigencrypt('1@p', 'MATRIX'), 'Invalid message')
})

test_that('supplying an empty keyword to vigdecrypt rasies an error', {
  expect_error(vigdecrypt('imperialcollege', ''), 'Invalid key')
})
