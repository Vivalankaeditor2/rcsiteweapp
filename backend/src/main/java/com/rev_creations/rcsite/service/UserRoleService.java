package com.rev_creations.rcsite.service;

import com.rev_creations.rcsite.config.AuthProperties;
import com.rev_creations.rcsite.entity.UserType;
import com.rev_creations.rcsite.repository.UserTypeRepository;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Resolves an {@code rc_customer.type} value to a role name.
 *
 * <p>There is no foreign key between {@code rc_customer} and {@code usertype}
 * (D-004: no schema change), so the link is by convention: {@code type} may hold
 * a {@code usertype.usertypeid} or a {@code usertypename}. The lookup table is
 * tiny, so it is read whole and matched in memory.
 */
@Service
public class UserRoleService {

    private final UserTypeRepository userTypeRepository;
    private final AuthProperties authProperties;

    public UserRoleService(UserTypeRepository userTypeRepository, AuthProperties authProperties) {
        this.userTypeRepository = userTypeRepository;
        this.authProperties = authProperties;
    }

    /**
     * The role name (no prefix) for a user. An unknown but non-blank {@code type}
     * is used as-is rather than dropped, so a role configured directly on the row
     * still works; a blank value falls back to the configured default.
     */
    public String resolveRoleName(String type) {
        if (type == null || type.isBlank()) {
            return authProperties.getDefaultRole();
        }
        String value = type.trim();
        List<UserType> types = userTypeRepository.findAll();
        Long id = parseId(value);
        if (id != null) {
            for (UserType candidate : types) {
                if (id.equals(candidate.getUserTypeId())) {
                    return candidate.getUserTypeName();
                }
            }
        }
        for (UserType candidate : types) {
            if (candidate.getUserTypeName() != null
                    && candidate.getUserTypeName().equalsIgnoreCase(value)) {
                return candidate.getUserTypeName();
            }
        }
        return value;
    }

    /** The Spring authority for a role name, e.g. {@code ADMIN -> ROLE_ADMIN}. */
    public String toAuthority(String roleName) {
        return authProperties.getRolePrefix() + roleName;
    }

    private static Long parseId(String value) {
        try {
            return Long.valueOf(value);
        } catch (NumberFormatException notNumeric) {
            return null;
        }
    }
}
