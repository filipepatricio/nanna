module.exports = {
  rules: {
    'header-min-length': [2, 'always', 3],
    'header-max-length': [2, 'always', 72],
    'scope-case': [2,'always','lower-case'],
    'header-full-stop': [2, 'never', '.'],
    'body-leading-blank': [2, 'always'],
    'body-case': [
        2,
        'always',
        ['sentence-case', 'start-case', 'pascal-case', 'upper-case'],
    ],
    'type-enum': [2,'always',['feat','fix']],
    'type-case': [2,'always','lower-case'],
    'type-empty': [2,'never'],
  }
}
