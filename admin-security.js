const express = require("express");

const originalGet = express.application.get;
const originalListen = express.application.listen;

function protectAdmin(req, res, next) {
    const adminUser = process.env.ADMIN_USER;
    const adminPassword = process.env.ADMIN_PASSWORD;

    if (!adminUser || !adminPassword) {
        if (process.env.NODE_ENV === "production") {
            return res.status(404).send("Not Found");
        }

        return next();
    }

    const authorization = req.headers.authorization || "";

    if (!authorization.startsWith("Basic ")) {
        res.setHeader(
            "WWW-Authenticate",
            'Basic realm="TechPath Admin", charset="UTF-8"'
        );
        return res.status(401).send("Authentication required.");
    }

    let credentials;

    try {
        credentials = Buffer.from(
            authorization.slice(6),
            "base64"
        ).toString("utf8");
    } catch {
        return res.status(401).send("Invalid authentication.");
    }

    const separatorIndex = credentials.indexOf(":");

    if (separatorIndex === -1) {
        return res.status(401).send("Invalid authentication.");
    }

    const username = credentials.slice(0, separatorIndex);
    const password = credentials.slice(separatorIndex + 1);

    if (username !== adminUser || password !== adminPassword) {
        res.setHeader(
            "WWW-Authenticate",
            'Basic realm="TechPath Admin", charset="UTF-8"'
        );
        return res.status(401).send("Invalid admin credentials.");
    }

    next();
}

express.application.get = function patchedGet(path, ...handlers) {
    if (
        handlers.length > 0 &&
        (path === "/admin" || path === "/api/admin/dashboard")
    ) {
        return originalGet.call(
            this,
            path,
            protectAdmin,
            ...handlers
        );
    }

    return originalGet.call(this, path, ...handlers);
};

express.application.listen = function patchedListen(...args) {
    if (!this.locals.techPathHealthRouteAdded) {
        originalGet.call(this, "/health", (req, res) => {
            res.status(200).json({
                status: "ok",
                service: "TechPath"
            });
        });

        this.locals.techPathHealthRouteAdded = true;
    }

    return originalListen.apply(this, args);
};
