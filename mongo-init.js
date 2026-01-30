// Run at first MongoDB init only. Creates app user in appDb.
// Authenticate as root (created by MONGO_INITDB_ROOT_*).
db.getSiblingDB('admin').auth(
  process.env.MONGO_INITDB_ROOT_USERNAME,
  process.env.MONGO_INITDB_ROOT_PASSWORD
);

db = db.getSiblingDB('portfolioDb');
db.createUser({
  user: 'portfolioDbUser',
  pwd: process.env.MONGO_APP_USER_PASSWORD,
  roles: [{ role: 'readWrite', db: 'portfolioDb' }]
});
