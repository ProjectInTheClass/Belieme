package com.example.beliemeserver.model.service;

import com.example.beliemeserver.model.util.HttpRequest;

import com.example.beliemeserver.model.dao.AuthorityDao;
import com.example.beliemeserver.model.dao.UserDao;

import com.example.beliemeserver.model.dto.AuthorityDto;
import com.example.beliemeserver.model.dto.UserDto;

import com.example.beliemeserver.model.exception.*;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class UserService {
    private static final String client_id = "a4b1abe746f384c3d43fa82a17f222";
    private static final Set<String> CSE_SOSOK_ID = new HashSet<>(Arrays.asList("FH04067"));

    private final UserDao userDao;
    private final AuthorityDao authorityDao;

    public UserService(UserDao userDao, AuthorityDao authorityDao) {
        this.userDao = userDao;
        this.authorityDao = authorityDao;
    }

    public UserDto getUserInfoFromUnivApiByApiToken(String apiToken) throws DataException, ConflictException, NotFoundException, ForbiddenException, BadGateWayException {
        JSONObject jsonResponse = getStudentInfoFromHanyangApi(apiToken);
        String studentId = (String) (jsonResponse.get("gaeinNo"));
        String name = (String) (jsonResponse.get("userNm"));
        String sosokId = (String) jsonResponse.get("sosokId");

        UserDto savedUser = setUserAndUpdateDB(studentId, name);

        if(savedUser.getMaxPermission() == null) {
            AuthorityDto newAuthority = addAuthority(savedUser, sosokId);
            savedUser.addAuthority(newAuthority);
        }

        return savedUser;
    }

    public UserDto getUserByUserToken(String userToken) throws DataException, UnauthorizedException {
        UserDto user;
        try {
            user = userDao.getUserByTokenData(userToken);
        } catch (NotFoundException e) {
            e.printStackTrace();
            throw new UnauthorizedException("There is no user in User-Token.");
        }
        return user;
    }

    private JSONObject getStudentInfoFromHanyangApi(String apiToken) throws BadGateWayException {
        Map<String, String> headers = new HashMap<>();
        headers.put("Host", "https://api.hanyang.ac.kr/");
        headers.put("client_id", client_id);
        headers.put("swap_key", Long.toString(System.currentTimeMillis()/1000));
        headers.put("access_token", apiToken);
        String responseString = null;
        responseString = HttpRequest.sendGetRequest("https://api.hanyang.ac.kr/rs/user/loginInfo.json", headers);

        JSONParser jsonParser = new JSONParser();
        JSONObject jsonResponse;
        try {
            jsonResponse = (JSONObject) jsonParser.parse(responseString);
        } catch (ParseException e) {
            e.printStackTrace();
            throw new BadGateWayException("Response of Hanyang Api does not fit into JSON Format.");
        }
        jsonResponse = (JSONObject) jsonResponse.get("response");
        jsonResponse = (JSONObject) jsonResponse.get("item");
        return jsonResponse;
    }

    private UserDto setUserAndUpdateDB(String studentId, String name) throws DataException, ConflictException, NotFoundException {
        boolean isNew = false;

        UserDto newUser;
        try {
            newUser = userDao.getUserByStudentIdData(studentId);
        } catch (NotFoundException e) {
            isNew = true;
            newUser = new UserDto();
            newUser.setCreateTimeStampNow();
        }

        newUser.setStudentId(studentId);
        newUser.setName(name);
        newUser.setNewToken();
        newUser.setApprovalTimeStampNow();

        if(isNew) {
            return userDao.addUserData(newUser);
        } else {
            return userDao.updateUserData(studentId, newUser);
        }
    }

    private AuthorityDto addAuthority(UserDto savedUser, String sosokId) throws ConflictException, DataException, ForbiddenException {
        if(CSE_SOSOK_ID.contains(sosokId)) {
            AuthorityDto newAuthority = AuthorityDto.builder()
                    .permission(AuthorityDto.Permission.USER)
                    .userDto(savedUser)
                    .build();

            return authorityDao.addAuthorityData(newAuthority);

        } else {
            throw new ForbiddenException("You're not CSE student.");
        }
    }
}
