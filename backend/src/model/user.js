module.exports = (sequelize, DataTypes) => {
  const User = sequelize.define('User', {
    id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },
    name: {
      type: DataTypes.STRING(50),
      allowNull: false,
    },
    image: {
      type: DataTypes.STRING(255),
      defaultValue: null,
    },
  });
  User.associate = (db) => {
    db.User.hasMany(db.Issue, {
      foreignKey: 'user_id',
    });
    db.User.hasMany(db.Comment, {
      foreignKey: 'user_id',
    });
    db.User.hasMany(db.AssigneeIssue, {
      foreignKey: 'user_id',
    });
  };
  return User;
};