import { DataTypes } from 'sequelize';

module.exports = (sequelize) => {
    const User = sequelize.define(
        'User',
        {
            username: {
                type: DataTypes.STRING(10),
                allowNull: false,
                primaryKey: true,
            },
            password: {
                type: DataTypes.STRING,
            },
            salt: {
                type: DataTypes.STRING(50),
            },
            role: {
                type: DataTypes.STRING(10),
            },
        },
        {
            tableName: 'users',
        }
    );
    return User;
};
