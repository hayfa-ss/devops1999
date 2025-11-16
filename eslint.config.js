import eslint from "eslint";
import securityPlugin from "eslint-plugin-security";
import nodePlugin from "eslint-plugin-node";
import promisePlugin from "eslint-plugin-promise";

export default [
  {
    files: ["**/*.js"],
    languageOptions: {
      ecmaVersion: 2021,
      sourceType: "module"
    },
    plugins: {
      security: securityPlugin,
      node: nodePlugin,
      promise: promisePlugin
    },
    rules: {
      "no-var": "warn",
      "semi": ["warn", "always"]
    },
    ignores: ["node_modules/**", "target/**"]
  }
];
