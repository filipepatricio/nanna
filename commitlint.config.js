module.exports = {
  rules: {
    'header-min-length': [2, 'always', 3],
    'header-max-length': [2, 'always', 72],
    'header-case': [
      2,
      'always',
      ['sentence-case', 'start-case', 'pascal-case', 'upper-case'],
    ],
    'header-full-stop': [2, 'never', '.'],
    'body-leading-blank': [2, 'always'],
    'body-max-line-length': [2, 'always', 72],
    'body-case': [
      2,
      'always',
      ['sentence-case', 'start-case', 'pascal-case', 'upper-case'],
    ],
  }
}
