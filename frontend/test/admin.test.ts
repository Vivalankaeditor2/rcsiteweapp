import { test } from "node:test";
import assert from "node:assert/strict";
import { isAdmin, type AdminSession } from "../src/lib/auth";
import { publicArticlePath } from "../src/lib/admin-links";

function session(roles: string[]): AdminSession {
  return {
    token: "t",
    tokenType: "Bearer",
    expiresInSeconds: 3600,
    user: { username: "u", displayName: null, email: null, roles },
  };
}

test("only an ADMIN role is treated as admin", () => {
  assert.equal(isAdmin(session(["ADMIN"])), true);
  assert.equal(isAdmin(session(["USER"])), false);
  assert.equal(isAdmin(session([])), false);
  assert.equal(isAdmin(null), false);
});

test("the admin 'view on site' link mirrors the frozen article URL contract", () => {
  // Numeric dcode replaces the id (the legacy "custom" id form).
  assert.equal(
    publicArticlePath({ articleId: 12272011, dcode: "12272011", alias: "hello-world" }),
    "/newspage/12272011ai-hello-world",
  );
  // A non-numeric dcode leaves the id in place.
  assert.equal(
    publicArticlePath({ articleId: 42, dcode: "hosted", alias: "a-slug" }),
    "/newspage/42ai-a-slug",
  );
  // No alias falls back to the query form.
  assert.equal(
    publicArticlePath({ articleId: 7, dcode: "hosted", alias: null }),
    "/news/page.jsp?articleid=7",
  );
});
