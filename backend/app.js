const express = require('express');
const { graphqlHTTP } = require('express-graphql');
const { buildSchema } = require('graphql');

const schema = buildSchema(`
  type Query {
    spinRoulette: String
  }
`);

const root = {
  spinRoulette: () => {
    const outcomes = ['Red', 'Black', 'Green'];
    const result = outcomes[Math.floor(Math.random() * outcomes.length)];
    return `You landed on ${result}`;
  }
};

const app = express();
app.use('/api', graphqlHTTP({
  schema,
  rootValue: root,
  graphiql: true
}));

app.listen(4000, () => console.log('Backend running at http://localhost:4000/api'));

