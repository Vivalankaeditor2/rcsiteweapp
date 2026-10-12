package com.rev_creations.rcsite.entity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

/** Small config/content table. Legacy column names are capitalised. */
@Entity
@Table(name = "readme")
@Getter
@Setter
public class ReadmeEntry {
    @Id
    @Column(name = "id")
    private Integer id;

    @Column(name = "Message", columnDefinition = "text")
    private String message;

    @Column(name = "Email", columnDefinition = "text")
    private String email;

    @Column(name = "Bitcoin_Address", columnDefinition = "text")
    private String bitcoinAddress;
}
