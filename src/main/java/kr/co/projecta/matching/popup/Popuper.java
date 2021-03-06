package kr.co.projecta.matching.popup;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

public class Popuper {
	String name;
	int height;
	int width;
	String head;
	String body;
	String foot;
	
	public Popuper(String name, int height, int width, String head, String body) {
		this.name = name;
		this.height = height;
		this.width = width;
		this.head = head;
		this.body = body;
	}
	public Popuper(String name, int height, int width, String head, String body, String foot) {
		this.name = name;
		this.height = height;
		this.width = width;
		this.head = head;
		this.body = body;
		this.foot = foot;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getHeight() {
		return height;
	}
	public void setHeight(int height) {
		this.height = height;
	}
	public int getWidth() {
		return width;
	}
	public void setWidth(int width) {
		this.width = width;
	}
	public String getHead() {
		return head;
	}
	public void setHead(String head) {
		this.head = head;
	}
	public String getBody() {
		return body;
	}
	public void setBody(String body) {
		this.body = body;
	}
	public String getFoot() {
		return foot;
	}
	public void setFoot(String foot) {
		this.foot = foot;
	}
	
	public String toString() {
		return ToStringBuilder.reflectionToString(
				this, ToStringStyle.NO_CLASS_NAME_STYLE);
	}
}
