# Implement generate_key_string function
# Given a message and a keyword, this function returns a key string of the
# appropriate length
generate_key_string <- function(message, key) {
  # Compute the length of the message and the length of the keyword as these
  # quantities are used multiple times in this function
  len_message <- nchar(message)
  len_key <- nchar(key)
  # Compute the quotient and the remainder when the length of the message is
  # divided by the length of the keyword
  quotient <- len_message %/% len_key
  remainder <- len_message %% len_key
  # Use the quotient and the remainder to compute the key string
  part_one = paste(replicate(quotient, key), collapse = '')
  part_two = substr(key, 1, remainder)
  return(paste(part_one, part_two, sep = ''))
}

# Implement letter_units function
# Given a letter, this function returns its position in the alphabet
letter_units <- function(letter) {
  alphabet <- letters[1:26]
  return(match(tolower(letter), alphabet) - 1)
}

# implement shift_n_units function
# Given a letter and an integer n, this function returns the letter
# n positions later in the alphabet
shift_n_units <- function(letter, n) {
  # Consider the case when letter is lower case
  if (letter == tolower(letter)){
    return(intToUtf8((utf8ToInt(letter) - 97 + n %% 26) %% 26 + 97))
  }
  # Consider the alternative case when letter is upper case
  else if (letter == toupper(letter)){
    return(intToUtf8((utf8ToInt(letter) - 65 + n %% 26) %% 26 + 65))
  }
}

#' Function to encrypt a message using the Vigenere cipher.
#' 
#' @param message A string containing the message to be encrypted in lower
#' case.
#' 
#' @param key A string containing the keyword in upper case.
#' 
#' @details Given a \code{message} and a \code{key}, this function encrypts the
#' message. NOTE: if \code{message} or \code{key} contain any non-alphabetic
#' characters, an error is raised.
#' 
#' @return The encrypted value of the message using the Vigenere cipher with the
#' specified keyword.
#' 
#' @examples
#' 
#' vigencrypt('imperialcollege', 'MATRIX')
#' # returns 'UMIVZFMLVFTIQGX'
#' 
#' @export

vigencrypt <- function(message, key) {
  errors <- character(0)
  # Defensive programming: Check that message contains only lower case
  # alphabetic characters and is of non-zero length
  if (!grepl('^[a-z]+$', message)) {
    errors <- c(errors, 'Invalid message')
  }
  # Defensive programming: Check that key contains only upper case alphabetic
  # characters and is of non-zero length
  if (!grepl('^[A-Z]+$', key)) {
    errors <- c(errors, 'Invalid key')
  }
  if (length(errors) > 0) {
    stop(paste(errors, collapse = ', '))
  } else {
      # Compute the key string
      key_string <- generate_key_string(message, key)
      # Perform encryption one letter at a time using the shift_n_units and
      # letter_units functions defined above
      encrypted <- ''
      for (i in 1:nchar(message)) {
        encrypted <- paste0(encrypted,
                            shift_n_units(substr(message, i, i),
                                          letter_units(substr(key_string, i, i))))
      }
      # Convert to upper case to be consistent with the brief
      encrypted <- toupper(encrypted)
      return(encrypted)
  }
}

#' Function to decrypt a message using the Vigenere cipher.
#' 
#' @param message A string containing the message to be decrypted in upper case.
#' 
#' @param key A string containing the keyword in upper case.
#' 
#' @details Given a \code{message} and a \code{key}, this function decrypts the
#' message. NOTE: if \code{message} or \code{key} contain any non-alphabetic
#' characters, an error is raised.
#' 
#' @return The decrypted value of the message using the Vigenere cipher with the
#' specified keyword.
#' 
#' @examples
#' 
#' vigdecrypt('UMIVZFMLVFTIQGX', 'MATRIX')
#' # returns 'imperialcollege'
#' 
#' @export

vigdecrypt <- function(message, key) {
  errors <- character(0)
  # Defensive programming: Check that message contains only upper case
  # alphabetic characters and is of non-zero length
  if (!grepl('^[A-Z]+$', message)) {
    errors <- c(errors, 'Invalid message')
  }
  # Defensive programming: Check that key contains only upper case alphabetic
  # characters and is of non-zero length
  if (!grepl('^[A-Z]+$', key)) {
    errors <- c(errors, 'Invalid key')
  }
  if (length(errors) > 0) {
    stop(paste(errors, collapse = ', '))
  } else {
    # Compute the key string
    key_string <- generate_key_string(message, key)
    # Perform decryption one letter at a time using the shift_n_units and
    # letter_units functions defined above
    decrypted <- ''
    for (i in 1:nchar(message)) {
      decrypted <- paste0(decrypted,
                          shift_n_units(substr(message, i, i),
                                        -letter_units(substr(key_string, i, i))))
    }
    # Convert to lower case to be consistent with the brief
    decrypted <- tolower(decrypted)
    return(decrypted)
  }
}
