# import the following core module for regular expression operations
import re

def generate_key_string(message: str, key: str) -> str:
    '''
    Given a message and a keyword, this function returns a key string of the
    appropriate length.

    Args:
        message: A string containing the message.
        key: A string containing the keyword.

    Returns:
        The key string.
    '''
    # Compute the quotient and the remainder when the length of the message is
    # divided by the length of the keyword
    quotient, remainder = divmod(len(message), len(key))
    # Use the quotient and the remainder to compute the key string
    return key * quotient + key[:remainder]

def letter_units(letter: str) -> int:
    '''
    Given a letter, this function returns its position in the alphabet.

    Args:
        letter: A string containing the letter.

    Returns:
        The position of the letter in the alphabet.
    '''
    # Subtracting 97 from a letter's Unicode code to compute its position in the
    # alphabet requires it to be lower case
    return ord(letter.lower()) - 97

def shift_n_units(letter: str, n: int) -> str:
    '''
    Given a letter and an integer n, this function returns the letter n positions
    later in the alphabet.

    Args:
        letter: A string containing the letter.
        n: An integer specifying the amount to shift the letter by.

    Returns:
        The letter n positions later in the alphabet.
    '''
    # Consider the case when letter is lower case
    if letter.islower():
        return chr((ord(letter) - 97 + n % 26) % 26 + 97)
    # Consider the alternative case when letter is upper case
    elif letter.isupper():
        return chr((ord(letter) - 65 + n % 26) % 26 + 65)

def vigencrypt(message: str, key: str) -> str:
    '''
    Given a message and a key, this function encrypts the message.

    Args:
        message: A string containing the message to be encrypted in lower case.
        key: A string containing the keyword in upper case.
            NOTE: if message or key contain any non-alphabetic characters, an
            error will be raised.

    Returns:
        The encrypted value of the message using the Vigenere cipher with the
        specified keyword.

    Example usage:
        print(vigencrypt('imperialcollege', 'MATRIX')) # returns 'UMIVZFMLVFTIQGX'
    '''
    errors = []
    # Defensive programming: Check that message contains only lower case
    # alphabetic characters and is of non-zero length
    if not re.match('^[a-z]+$', message):
        errors.append('Invalid message')
    # Defensive programming: Check that key contains only upper case alphabetic
    # characters and is of non-zero length
    if not re.match('^[A-Z]+$', key):
        errors.append('Invalid key')
    if errors:
        raise ValueError(', '.join(errors))
    else:
        # Compute the key string
        key_string = generate_key_string(message, key)
        # Perform encryption one letter at a time using the shift_n_units and
        # letter_units functions defined above
        encrypted = ''
        for i, c in enumerate(message):
            encrypted += shift_n_units(c, letter_units(key_string[i]))
        # Convert to upper case to be consistent with the brief
        encrypted = encrypted.upper()
        return encrypted

def vigdecrypt(message: str, key: str) -> str:
    '''
    Given a message and a key, this function decrypts the message.

    Args:
        message: A string containing the message to be decrypted in upper case.
        key: A string containing the keyword in upper case.
            NOTE: if message or key contain any non-alphabetic characters, an
            error will be raised.

    Returns:
        The decrypted value of the message using the Vigenere cipher with the
        specified keyword.

    Example usage:
        print(vigdecrypt('UMIVZFMLVFTIQGX', 'MATRIX')) # returns 'imperialcollege'
    '''
    errors = []
    # Defensive programming: Check that message contains only upper case
    # alphabetic characters and is of non-zero length
    if not re.match('^[A-Z]+$', message):
        errors.append('Invalid message')
    # Defensive programming: Check that key contains only upper case alphabetic
    # characters and is of non-zero length
    if not re.match('^[A-Z]+$', key):
        errors.append('Invalid key')
    if errors:
        raise ValueError(', '.join(errors))
    else:
        # Compute the key string
        key_string = generate_key_string(message, key)
        # Perform decryption one letter at a time using the shift_n_units and
        # letter_units functions defined above
        decrypted = ''
        for i, c in enumerate(message):
            decrypted += shift_n_units(c, -letter_units(key_string[i]))
        # Convert to lower case to be consistent with the brief
        decrypted = decrypted.lower()
        return decrypted
