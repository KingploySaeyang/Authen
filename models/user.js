
const mongoose = require('mongoose');

const userSchema = new mongoose.Schema(
    {
    user_name: { type: String, required: true },
    password: { type: String, required: true },
    name: { type: Number, required: true },
    role: { type: String, required: true },
    },
    {timestamps: true, versionKey: false}
);

const User = moongoose.model("User", userSchema)
module.exports = user