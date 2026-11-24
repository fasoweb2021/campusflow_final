const jsonServer = require('json-server');
const server = jsonServer.create();
const router = jsonServer.router('db.json');
const jetonsValides = new Set(); // en mémoire : un redémarrage invalide les jetons

server.use(jsonServer.defaults());
server.use(jsonServer.bodyParser);

server.post('/login', (req, res) => {
  const { email, password } = req.body || {};
  const user = router.db.get('utilisateurs').find({ email, password }).value();
  if (!user) return res.status(401).json({ message: 'Identifiants invalides' });
  const { password: _, ...publicUser } = user;
  const token = `fake-jwt-${user.id}-${Date.now()}`;
  jetonsValides.add(token);
  res.json({ token, user: publicUser });
});

server.use((req, res, next) => {
  const auth = req.headers.authorization || '';
  const token = auth.replace(/^Bearer /, '');
  if (!jetonsValides.has(token)) {
    return res.status(401).json({ message: 'Non authentifié' });
  }
  next();
});

server.use(router);
server.listen(3000, '0.0.0.0', () => console.log('API sur http://localhost:3000'));

