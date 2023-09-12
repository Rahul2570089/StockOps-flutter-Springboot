package com.example.demo.controllers;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.demo.payload.ApiResponse;
import com.example.demo.payload.UserDto;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/api/users")
public class SessionController {

	@GetMapping("/session/create/{id}/{email}/{password}")
	public ResponseEntity<ApiResponse> setUser(HttpServletRequest request, @PathVariable Integer id, @PathVariable String email, @PathVariable String password) {
		HttpSession session = request.getSession();
		session.setAttribute("id", id);
		session.setAttribute("email", email);
		session.setAttribute("password", password);
		return new ResponseEntity<ApiResponse>(new ApiResponse("Session created", true), HttpStatus.OK);
	}
	
	@GetMapping("/session/getUser")
	public ResponseEntity<UserDto> getUser(HttpSession session) {
		Integer id = (Integer) session.getAttribute("id");
	    String email = (String) session.getAttribute("email");
	    String password = (String) session.getAttribute("password");
	    UserDto userDto = new UserDto();
	    userDto.setId(id);
	    userDto.setEmail(email);
	    userDto.setPassword(password);
	    return new ResponseEntity<UserDto>(userDto, HttpStatus.OK);
	}
	
	@GetMapping("/session/delete")
	public ResponseEntity<ApiResponse> logout(HttpSession session) {
	    session.invalidate();
	    return new ResponseEntity<ApiResponse>(new ApiResponse("Session deleted", true), HttpStatus.OK);
	}
}
