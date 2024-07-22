
/**
 * @see https://prettier.io/docs/en/configuration.html
 * @type {import("prettier").Config}
 */
const config = {
  useTabs: false,
  tabWidth: 2,
  endOfLine: 'lf',
  printWidth: 160,
  singleQuote: true,
  trailingComma: 'all',
  plugins: ["./node_modules/@typespec/prettier-plugin-typespec"],
  overrides:[
    {
      files: "*.tsp",
      options: {
        parser: "typespec"
      }
    }
  ]
}

export default config
