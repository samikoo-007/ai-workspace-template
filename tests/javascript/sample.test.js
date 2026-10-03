function formatUser(name, role) {
  return {
    name,
    role,
    createdAt: new Date().toISOString(),
  };
}

describe('Workspace JavaScript smoke tests', () => {
  test('formats a user object', () => {
    const user = formatUser('Ada', 'Developer');
    expect(user.name).toBe('Ada');
    expect(user.role).toBe('Developer');
    expect(user.createdAt).toBeDefined();
  });

  test('environment sanity check', () => {
    expect(true).toBe(true);
  });
});
