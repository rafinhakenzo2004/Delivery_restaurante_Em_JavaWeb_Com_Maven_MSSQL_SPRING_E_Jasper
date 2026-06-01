package com.fatec.restaurante.converter;

import com.fatec.restaurante.model.TipoPrato;
import com.fatec.restaurante.repository.TipoPratoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.core.convert.converter.Converter;
import org.springframework.stereotype.Component;

/**
 * SOLID - SRP: Responsável apenas por converter String (idTipo) -> TipoPrato.
 * SOLID - DIP: Depende da abstração TipoPratoRepository.
 */
@Component
@RequiredArgsConstructor
public class TipoPratoConverter implements Converter<String, TipoPrato> {

    private final TipoPratoRepository tipoPratoRepository;

    @Override
    public TipoPrato convert(String id) {
        if (id == null || id.isBlank()) return null;
        return tipoPratoRepository.findById(Integer.parseInt(id)).orElse(null);
    }
}