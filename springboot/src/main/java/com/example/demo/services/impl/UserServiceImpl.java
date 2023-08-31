package com.example.demo.services.impl;

import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.entites.User;
import com.example.demo.exceptions.ResourceNotFoundExceptionHandler;
import com.example.demo.payload.UserDto;
import com.example.demo.repositories.UserRepository;
import com.example.demo.services.UserService;

@Service
public class UserServiceImpl implements UserService {

	@Autowired
	private UserRepository userRepository;
	
	@Autowired
	private ModelMapper modelMapper;
	
	@Override
	public UserDto createUser(UserDto userDto) {
		User user = toUser(userDto);
		User newUser = this.userRepository.save(user);
		return toUserDto(newUser);
	}
  
	@Override
	public UserDto updateUser(UserDto userDto, Integer userId) {
		User userUpdated = this.userRepository.findById(userId).orElseThrow(()-> new ResourceNotFoundExceptionHandler("User", "ID", userId));
		userUpdated.setEmail(userDto.getEmail());
		userUpdated.setPassword(userDto.getPassword());
		return toUserDto(userUpdated);
	}

	@Override
	public UserDto getUserById(Integer userId) {
		User user = this.userRepository.findById(userId).orElseThrow(()-> new ResourceNotFoundExceptionHandler("User", "ID", userId));
		return toUserDto(user);
	}

	@Override
	public List<UserDto> getAllUsers() {
		List<User> users = this.userRepository.findAll();
		List<UserDto> usersDto = users.stream().map(user -> toUserDto(user)).collect(Collectors.toList());
		return usersDto;
	}

	@Override
	public void deleteUser(Integer userId) {
		User user = this.userRepository.findById(userId).orElseThrow(()-> new ResourceNotFoundExceptionHandler("User", "ID", userId));
		this.userRepository.delete(user);
	}
	
	private UserDto toUserDto(User user) {
		UserDto userDto = this.modelMapper.map(user, UserDto.class);
		return userDto;
	}
	
	private User toUser(UserDto userDto) {
		User user = this.modelMapper.map(userDto, User.class);
		return user;
	}

}
