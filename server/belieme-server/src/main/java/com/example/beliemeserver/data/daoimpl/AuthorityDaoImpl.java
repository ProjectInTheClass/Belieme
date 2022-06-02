package com.example.beliemeserver.data.daoimpl;

import com.example.beliemeserver.data.entity.AuthorityEntity;
import com.example.beliemeserver.data.entity.UserEntity;
import com.example.beliemeserver.data.entity.id.AuthorityId;
import com.example.beliemeserver.data.entity.id.UserId;
import com.example.beliemeserver.data.repository.AuthorityRepository;
import com.example.beliemeserver.model.dao.AuthorityDao;
import com.example.beliemeserver.model.dto.AuthorityDto;
import com.example.beliemeserver.model.exception.ConflictException;
import com.example.beliemeserver.model.exception.DataException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AuthorityDaoImpl implements AuthorityDao {
    @Autowired
    AuthorityRepository authorityRepository;

    @Override
    public AuthorityDto addAuthorityData(AuthorityDto authorityDto) throws ConflictException, DataException {
        if(authorityRepository.existsById(new AuthorityId(new UserId(authorityDto.getUserDto().getStudentId())))) {
            throw new ConflictException();
        }
        AuthorityEntity newAuthority = AuthorityEntity.builder()
                .user(UserEntity.from(authorityDto.getUserDto()))
                .permission(authorityDto.getPermission().toString())
                .build();
        return authorityRepository.save(newAuthority).toAuthorityDto();
    }
}
